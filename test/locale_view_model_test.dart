import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/localization/locale_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LocaleViewModel> _make({
  Map<String, Object> saved = const {},
  Locale? device,
}) async {
  SharedPreferences.setMockInitialValues(saved);
  return LocaleViewModel(
    await SharedPreferences.getInstance(),
    deviceLocale: device,
  );
}

void main() {
  group('first launch', () {
    test('follows the phone when it speaks Arabic', () async {
      final vm = await _make(device: const Locale('ar', 'EG'));
      expect(vm.locale, LocaleViewModel.arabic);
      expect(vm.isArabic, isTrue);
    });

    test('follows the phone when it speaks English', () async {
      final vm = await _make(device: const Locale('en', 'US'));
      expect(vm.locale, LocaleViewModel.english);
    });

    test('falls back to English for a language the app lacks', () async {
      final vm = await _make(device: const Locale('fr', 'FR'));
      expect(vm.locale, LocaleViewModel.english);
    });

    test('falls back to English when there is no phone locale at all',
        () async {
      final vm = await _make();
      expect(vm.locale, LocaleViewModel.english);
    });
  });

  group('remembered choice', () {
    test('wins over the phone, so a choice survives a restart', () async {
      final vm = await _make(
        saved: {'languageCode': 'ar'},
        device: const Locale('en', 'US'),
      );
      expect(vm.locale, LocaleViewModel.arabic);
    });

    test('ignores a saved language the app no longer supports', () async {
      final vm = await _make(
        saved: {'languageCode': 'xx'},
        device: const Locale('ar'),
      );
      expect(vm.locale, LocaleViewModel.arabic, reason: 'falls through to phone');
    });
  });

  group('changing language', () {
    test('toggle flips between the two and notifies listeners', () async {
      final vm = await _make(device: const Locale('en'));
      var notified = 0;
      vm.addListener(() => notified++);

      await vm.toggle();
      expect(vm.isArabic, isTrue);
      await vm.toggle();
      expect(vm.isArabic, isFalse);
      expect(notified, 2);
    });

    test('saves the choice so the next launch starts in it', () async {
      final vm = await _make(device: const Locale('en'));
      await vm.toggle();

      final next = LocaleViewModel(
        await SharedPreferences.getInstance(),
        deviceLocale: const Locale('en'),
      );
      expect(next.locale, LocaleViewModel.arabic);
    });

    test('setting the current language again changes and saves nothing',
        () async {
      final vm = await _make(device: const Locale('en'));
      var notified = 0;
      vm.addListener(() => notified++);

      await vm.setLocale(LocaleViewModel.english);

      expect(notified, 0);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('languageCode'), isNull);
    });

    test('refuses a language the app does not have', () async {
      final vm = await _make(device: const Locale('en'));
      await vm.setLocale(const Locale('fr'));

      expect(vm.locale, LocaleViewModel.english);
    });
  });
}
