#!/usr/bin/env python3
"""Patch the freshly generated android/ folder so the build succeeds in CI.

Run from the repository root, after `flutter create . --platforms=android`:
    python3 scripts/patch_android.py

What it does (each step is safe to run more than once):
  1. Adds the INTERNET permission to AndroidManifest.xml.
  2. Raises the Kotlin Gradle plugin version to at least 2.2.20.
  3. Enables core library desugaring (compileOptions + dependency).
  4. Restores lib/ from app_src_backup/ if flutter create replaced main.dart.
  5. Compiles every plugin against Android API 36 (some plugins still
     declare an older compileSdk, which makes the build fail).
"""

import os
import re
import shutil
import sys

MIN_KOTLIN = (2, 2, 20)
FORCE_COMPILE_SDK = 36
SDK_MARKER = "NIG_VID compileSdk override"
DESUGAR_LIB = "com.android.tools:desugar_jdk_libs:2.1.4"

MANIFEST = os.path.join("android", "app", "src", "main", "AndroidManifest.xml")
SETTINGS_CANDIDATES = [
    os.path.join("android", "settings.gradle.kts"),
    os.path.join("android", "settings.gradle"),
]
ROOT_GRADLE_CANDIDATES = [
    os.path.join("android", "build.gradle.kts"),
    os.path.join("android", "build.gradle"),
]
APP_GRADLE_CANDIDATES = [
    os.path.join("android", "app", "build.gradle.kts"),
    os.path.join("android", "app", "build.gradle"),
]


def read(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def write(path, text):
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)


def first_existing(paths):
    for p in paths:
        if os.path.isfile(p):
            return p
    return None


def parse_version(text):
    parts = re.findall(r"\d+", text)[:3]
    nums = [int(x) for x in parts]
    while len(nums) < 3:
        nums.append(0)
    return tuple(nums)


# ---------------------------------------------------------------- manifest
def patch_manifest():
    if not os.path.isfile(MANIFEST):
        print("ERROR: %s not found. Did flutter create run?" % MANIFEST)
        return False
    text = read(MANIFEST)
    if "android.permission.INTERNET" in text:
        print("manifest: INTERNET permission already present")
        return True
    perm = '    <uses-permission android:name="android.permission.INTERNET"/>\n'
    match = re.search(r"<manifest[^>]*>\s*\n", text)
    if not match:
        print("ERROR: could not find <manifest> tag in %s" % MANIFEST)
        return False
    text = text[: match.end()] + perm + text[match.end():]
    write(MANIFEST, text)
    print("manifest: added INTERNET permission")
    return True


# ------------------------------------------------------------------ kotlin
def patch_kotlin_version():
    path = first_existing(SETTINGS_CANDIDATES)
    if path is None:
        print("ERROR: android/settings.gradle(.kts) not found")
        return False
    text = read(path)
    pattern = re.compile(
        r"""(org\.jetbrains\.kotlin\.android["']\)?\s+version\s+["'])([^"']+)(["'])"""
    )
    match = pattern.search(text)
    if not match:
        print("WARNING: Kotlin plugin version not found in %s; skipping" % path)
        return True
    current = match.group(2)
    if parse_version(current) >= MIN_KOTLIN:
        print("kotlin: %s already >= 2.2.20" % current)
        return True
    target = ".".join(str(n) for n in MIN_KOTLIN)
    text = pattern.sub(lambda m: m.group(1) + target + m.group(3), text)
    write(path, text)
    print("kotlin: %s -> %s in %s" % (current, target, path))
    return True


# --------------------------------------------------------------- desugaring
def patch_desugaring():
    path = first_existing(APP_GRADLE_CANDIDATES)
    if path is None:
        print("ERROR: android/app/build.gradle(.kts) not found")
        return False
    is_kts = path.endswith(".kts")
    text = read(path)

    flag_line = (
        "isCoreLibraryDesugaringEnabled = true"
        if is_kts
        else "coreLibraryDesugaringEnabled true"
    )

    # compileOptions block
    if "oreLibraryDesugaringEnabled" not in text:
        block = re.search(r"compileOptions\s*\{", text)
        if block:
            insert_at = block.end()
            text = text[:insert_at] + "\n        " + flag_line + text[insert_at:]
            print("desugaring: enabled in existing compileOptions")
        else:
            android = re.search(r"\nandroid\s*\{", text)
            if not android:
                print("ERROR: android { } block not found in %s" % path)
                return False
            new_block = "\n    compileOptions {\n        %s\n    }\n" % flag_line
            text = text[: android.end()] + new_block + text[android.end():]
            print("desugaring: added compileOptions block")
    else:
        print("desugaring: flag already present")

    # dependency
    if "coreLibraryDesugaring" not in text.replace(flag_line, ""):
        dep_line = (
            '    coreLibraryDesugaring("%s")' % DESUGAR_LIB
            if is_kts
            else '    coreLibraryDesugaring "%s"' % DESUGAR_LIB
        )
        deps = re.search(r"\ndependencies\s*\{", text)
        if deps:
            text = text[: deps.end()] + "\n" + dep_line + text[deps.end():]
        else:
            text = text.rstrip() + "\n\ndependencies {\n" + dep_line + "\n}\n"
        print("desugaring: added dependency")
    else:
        print("desugaring: dependency already present")

    write(path, text)
    return True



# ------------------------------------------------------------ compile SDK
KTS_BLOCK = """
// NIG_VID compileSdk override: compile every plugin against API %d.
subprojects {
    val sub = this
    fun forceCompileSdk() {
        val ext = sub.extensions.findByName("android")
        if (ext != null) {
            try {
                ext.javaClass
                    .getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                    .invoke(ext, %d)
            } catch (e: Exception) {
                println("compileSdk override skipped for ${sub.name}: $e")
            }
        }
    }
    if (sub.state.executed) {
        forceCompileSdk()
    } else {
        sub.afterEvaluate { forceCompileSdk() }
    }
}
"""

GROOVY_BLOCK = """
// NIG_VID compileSdk override: compile every plugin against API %d.
subprojects {
    def forceCompileSdk = { p ->
        def ext = p.extensions.findByName("android")
        if (ext != null) {
            try {
                ext.compileSdkVersion(%d)
            } catch (Exception e) {
                println("compileSdk override skipped for ${p.name}: ${e}")
            }
        }
    }
    if (project.state.executed) {
        forceCompileSdk(project)
    } else {
        afterEvaluate { forceCompileSdk(project) }
    }
}
"""


def patch_compile_sdk():
    path = first_existing(ROOT_GRADLE_CANDIDATES)
    if path is None:
        print("ERROR: android/build.gradle(.kts) not found")
        return False
    text = read(path)
    if SDK_MARKER in text:
        print("compileSdk: override already present")
        return True
    block = KTS_BLOCK if path.endswith(".kts") else GROOVY_BLOCK
    block = block % (FORCE_COMPILE_SDK, FORCE_COMPILE_SDK)
    write(path, text.rstrip() + "\n" + block)
    print("compileSdk: plugins will compile against API %d (%s)" % (FORCE_COMPILE_SDK, path))
    return True


# ------------------------------------------------------- app code restore
def restore_app_code():
    backup = "app_src_backup"
    main_dart = os.path.join("lib", "main.dart")
    if not os.path.isdir(backup):
        print("restore: no backup folder, skipping")
        return True
    current = read(main_dart) if os.path.isfile(main_dart) else ""
    if "NigVidApp" in current:
        print("restore: lib/main.dart is intact")
        return True
    shutil.rmtree("lib", ignore_errors=True)
    shutil.copytree(backup, "lib")
    print("restore: lib/ was replaced by flutter create, restored from backup")
    return True


def main():
    ok = True
    ok = restore_app_code() and ok
    ok = patch_manifest() and ok
    ok = patch_kotlin_version() and ok
    ok = patch_desugaring() and ok
    ok = patch_compile_sdk() and ok
    if not ok:
        print("patch_android.py FAILED")
        return 1
    print("patch_android.py finished OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
