import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/localization/l10n.dart';
import 'core/localization/locale_view_model.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/views/splash_screen.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleViewModel>().locale;

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      // Changing the locale rebuilds everything below, and Arabic flips the
      // whole layout to right-to-left on its own.
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.dark(locale),
      home: const SplashScreen(),
    );
  }
}
