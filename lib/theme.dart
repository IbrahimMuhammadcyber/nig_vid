import 'package:flutter/material.dart';

/// NIG_VID design tokens (from the brand spec).
class NvColors {
  static const Color bg = Color(0xFF080B14);
  static const Color bg2 = Color(0xFF101624);
  static const Color panel = Color(0xFF171F30);
  static const Color violet = Color(0xFF8057FF);
  static const Color cyan = Color(0xFF29D9F5);
  static const Color success = Color(0xFF3DDC97);
  static const Color warning = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF6B6B);
  static const Color text = Color(0xFFF2F4FA);
  static const Color textMuted = Color(0xFF93A0BC);
  static const Color border = Color(0xFF263049);
}

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: NvColors.violet,
    onPrimary: Colors.white,
    secondary: NvColors.cyan,
    onSecondary: Color(0xFF04222A),
    surface: NvColors.bg2,
    onSurface: NvColors.text,
    error: NvColors.error,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: NvColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: NvColors.bg,
      foregroundColor: NvColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: NvColors.bg2,
      indicatorColor: NvColors.violet.withAlpha(90),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: NvColors.text,
        side: const BorderSide(color: NvColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: NvColors.panel,
      hintStyle: const TextStyle(color: NvColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
