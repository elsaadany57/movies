import 'package:flutter/material.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_theme.dart';

/// A MaterialApp set up the way the real one is: translations loaded, the
/// app's theme, and a locale. Any widget that calls `context.l10n` needs this
/// above it; a bare MaterialApp has no translations to find.
Widget localizedApp({
  required Widget home,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.dark(locale),
    home: home,
  );
}
