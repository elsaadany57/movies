import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/localization/locale_view_model.dart';
import 'package:movies_app/features/auth/view_models/auth_view_model.dart';
import 'package:movies_app/features/auth/views/login_screen.dart';
import 'package:movies_app/features/auth/widgets/language_toggle.dart';
import 'package:movies_app/features/movies/widgets/featured_carousel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/app_harness.dart';
import 'helpers/fakes.dart';

final _english = lookupAppLocalizations(const Locale('en'));
final _arabic = lookupAppLocalizations(const Locale('ar'));

/// Mounts [home] the way the real app does: its language comes from a
/// [LocaleViewModel], so changing that view model re-words the whole screen.
Future<LocaleViewModel> _pump(
  WidgetTester tester,
  Widget home, {
  String? saved,
}) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'languageCode': ?saved});
  final locale = LocaleViewModel(
    await SharedPreferences.getInstance(),
    deviceLocale: const Locale('en'),
  );

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locale),
        ChangeNotifierProvider(create: (_) => AuthViewModel(FakeAuthRepository())),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (_, locale, _) =>
            localizedApp(locale: locale.locale, home: home),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return locale;
}

TextDirection _direction(WidgetTester tester, Type screen) =>
    Directionality.of(tester.element(find.byType(screen)));

void main() {
  group('login screen', () {
    testWidgets('speaks English and reads left to right by default', (tester) async {
      await _pump(tester, const LoginScreen());

      expect(find.text(_english.login), findsWidgets);
      expect(find.text(_english.forgetPasswordLink), findsOneWidget);
      expect(_direction(tester, LoginScreen), TextDirection.ltr);
    });

    testWidgets('speaks Arabic and reads right to left when Arabic is saved',
        (tester) async {
      await _pump(tester, const LoginScreen(), saved: 'ar');

      expect(find.text(_arabic.login), findsWidgets);
      expect(find.text(_arabic.forgetPasswordLink), findsOneWidget);
      expect(find.text(_arabic.loginWithGoogle), findsOneWidget);
      expect(find.text(_english.login), findsNothing, reason: 'no English left');
      expect(_direction(tester, LoginScreen), TextDirection.rtl);
    });

    testWidgets('validation messages come out in the current language',
        (tester) async {
      await _pump(tester, const LoginScreen(), saved: 'ar');

      await tester.tap(find.text(_arabic.login).last);
      await tester.pumpAndSettle();

      expect(find.text(_arabic.enterEmail), findsOneWidget);
      expect(find.text(_arabic.enterPassword), findsOneWidget);
      expect(find.text(_english.enterEmail), findsNothing);
    });
  });

  group('language toggle', () {
    testWidgets('switches the screen to Arabic at once, and remembers it',
        (tester) async {
      final locale = await _pump(tester, const LoginScreen());
      expect(find.text(_english.login), findsWidgets);

      await tester.tap(find.byType(LanguageToggle));
      await tester.pumpAndSettle();

      expect(locale.isArabic, isTrue);
      expect(find.text(_arabic.login), findsWidgets);
      expect(find.text(_english.login), findsNothing);
      expect(_direction(tester, LoginScreen), TextDirection.rtl);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('languageCode'), 'ar');
    });

    testWidgets('switches back to English just as readily', (tester) async {
      await _pump(tester, const LoginScreen(), saved: 'ar');

      await tester.tap(find.byType(LanguageToggle));
      await tester.pumpAndSettle();

      expect(find.text(_english.login), findsWidgets);
      expect(_direction(tester, LoginScreen), TextDirection.ltr);
    });

    testWidgets('stays put visually: the flags do not swap sides in Arabic',
        (tester) async {
      await _pump(tester, const LoginScreen());
      final flags = find.descendant(
        of: find.byType(LanguageToggle),
        matching: find.byType(Image),
      );
      final englishLeft = tester.getCenter(flags.first).dx;

      await tester.tap(find.byType(LanguageToggle));
      await tester.pumpAndSettle();

      expect(tester.getCenter(flags.first).dx, englishLeft);
    });
  });

  group('home headings', () {
    Future<void> pumpCarousel(WidgetTester tester, {String? saved}) {
      return _pump(
        tester,
        Scaffold(
          body: ListView(
            children: [
              FeaturedCarousel(movies: [for (var i = 1; i <= 4; i++) fakeMovie(i)]),
            ],
          ),
        ),
        saved: saved,
      );
    }

    testWidgets('use the design artwork in English', (tester) async {
      await pumpCarousel(tester);

      expect(find.text(_arabic.availableNow), findsNothing);
      expect(find.text(_english.availableNow), findsNothing,
          reason: 'the English words are inside the image, not text');
    });

    testWidgets('are real Arabic text instead, since an image cannot translate',
        (tester) async {
      await pumpCarousel(tester, saved: 'ar');

      expect(find.text(_arabic.availableNow), findsOneWidget);
      expect(find.text(_arabic.watchNow), findsOneWidget);
    });
  });
}
