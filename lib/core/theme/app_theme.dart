import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The design is dark-only, so there is a single theme; only its typeface
/// changes with the language.
class AppTheme {
  static const _latinFont = 'Inter';

  /// Inter has no Arabic letters, so Arabic is set in Cairo, and Cairo also
  /// backs up the English font in case Arabic text turns up inside it.
  static const _arabicFont = 'Cairo';

  static ThemeData dark(Locale locale) {
    final arabic = locale.languageCode == 'ar';

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: arabic ? _arabicFont : _latinFont,
      fontFamilyFallback: const [_arabicFont],
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.background,
        surface: AppColors.background,
        onSurface: AppColors.white,
        error: AppColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
