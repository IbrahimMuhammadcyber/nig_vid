import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/strings.dart';
import 'services/providers.dart';

/// App-wide state: language, locally saved prompts, provider registry.
class AppState extends ChangeNotifier {
  String lang = 'en';
  List<String> savedPrompts = <String>[];
  final ProviderRegistry providers = ProviderRegistry();

  static const String _langKey = 'lang';
  static const String _promptsKey = 'saved_prompts';

  String t(String key) => Strings.t(lang, key);

  /// Translation with a {n} placeholder.
  String tn(String key, int n) => t(key).replaceAll('{n}', n.toString());

  Future<void> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedLang = prefs.getString(_langKey);
      if (savedLang != null && Strings.supported.contains(savedLang)) {
        lang = savedLang;
      }
      savedPrompts = prefs.getStringList(_promptsKey) ?? <String>[];
    } catch (_) {
      // If storage is unavailable, keep defaults. The app still works.
    }
    notifyListeners();
  }

  Future<void> setLang(String newLang) async {
    if (!Strings.supported.contains(newLang)) return;
    lang = newLang;
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langKey, newLang);
    } catch (_) {
      // Preference just will not persist this time.
    }
  }

  /// Returns true only after the prompt has really been written to storage.
  Future<bool> addPrompt(String prompt) async {
    final List<String> updated = <String>[prompt, ...savedPrompts];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool ok = await prefs.setStringList(_promptsKey, updated);
      if (!ok) return false;
      savedPrompts = updated;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removePrompt(int index) async {
    if (index < 0 || index >= savedPrompts.length) return false;
    final List<String> updated = List<String>.from(savedPrompts)
      ..removeAt(index);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool ok = await prefs.setStringList(_promptsKey, updated);
      if (!ok) return false;
      savedPrompts = updated;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Gives every screen access to [AppState] and rebuilds it when state changes.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}
