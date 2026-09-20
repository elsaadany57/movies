import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The design is dark-only, so there is a single theme.
class AppTheme {
  static const fontFamily = 'Inter';

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: fontFamily,
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
