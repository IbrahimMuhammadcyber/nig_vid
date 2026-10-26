# NIG_VID

Imagine It. Create It. (Your Imagination, Your Studio.)

A Flutter Android app for AI video and image creation, in English and Hausa.
Built and compiled entirely from a phone using GitHub and GitHub Actions.

## Status: Phase 1 (honest foundation)

Working now:
- Cinematic dark theme with the brand colors.
- English and Hausa interface (language is remembered). Hausa text is a first
  draft and needs review by a native speaker.
- Bottom navigation: Home, Create, Projects, Templates, Profile.
- Prompt editor with character count, clear, and save (saved on this device).
- 14 editable starter templates with search and safety notes.
- Local drafts list (clearly marked as device-only).
- Provider layer and job-state definitions, with NO provider connected.

Not built yet, and the app says so instead of faking it:
- AI generation (Generate is disabled until a provider is connected).
- Accounts, cloud projects, credits and payments.
- Video editor, image upload, voice and subtitles.

Next phases (need a server, because API keys must never be inside the app):
1. Backend (free tier, for example Supabase): auth, projects, storage,
   credit ledger with atomic transactions.
2. Job queue plus worker that calls an AI provider and handles webhooks.
3. First real provider adapter, then image upload and image-to-video.
4. Video editor, subtitles, voice.

## Files

- pubspec.yaml
- .gitignore
- .github/workflows/build.yml
- scripts/patch_android.py
- lib/main.dart, app_state.dart, theme.dart, tools.dart, widgets.dart
- lib/l10n/strings.dart
- lib/services/providers.dart
- lib/data/templates.dart
- lib/screens/ shell, home, create, workspace, projects, templates, profile

The android/ folder is NOT in the repo. The workflow generates it on every run.

## Building the APK (all from your phone)

1. In your repo on GitHub (mobile web), tap Add file, then Create new file.
2. Type the full path in the name box, for example lib/screens/shell.dart.
   Typing a slash creates the folder automatically.
3. Paste the full file contents and tap Commit changes.
4. The file .gitignore starts with a dot. Type it exactly as .gitignore.
5. Each commit starts a build. Open the Actions tab to watch it.
6. When it is green, open the run, scroll to Artifacts, and download
   nig_vid-apk. Unzip it and install app-release.apk.

Tip: if a page looks cut down, use your browser menu and choose
"Desktop site" on the Actions page.

## If a build fails

Open the failed run, tap the failing step, and scroll to the END of its log.
The real error is in a block starting with FAILURE: or What went wrong:,
far below the setup and download lines.

Only trust the most recent run. The workflow cancels older runs when you push
again, so a cancelled run is normal.

## Rules baked into this project

- pubspec name is nig_vid (lowercase and underscores only).
- Java 17 is pinned with actions/setup-java.
- All Android patching is in scripts/patch_android.py, one step, no heredocs
  in the YAML.
- audio_service is intentionally not used. For audio later, use just_audio.
- Adding notification plugins later is safe: core library desugaring is
  already enabled by the patch script.
