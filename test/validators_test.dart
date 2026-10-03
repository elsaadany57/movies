import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/utils/validators.dart';

void main() {
  final english = lookupAppLocalizations(const Locale('en'));
  final arabic = lookupAppLocalizations(const Locale('ar'));
  final v = Validators(english);

  group('email', () {
    test('accepts real addresses', () {
      expect(v.email('ahmed@example.com'), isNull);
      expect(v.email('  ahmed@example.co.uk  '), isNull);
    });

    test('says what is missing when it is blank', () {
      expect(v.email(''), english.enterEmail);
      expect(v.email(null), english.enterEmail);
      expect(v.email('   '), english.enterEmail);
    });

    test('rejects malformed addresses', () {
      for (final bad in ['ahmed', 'ahmed@', 'ahmed@example', '@example.com']) {
        expect(v.email(bad), english.invalidEmail, reason: bad);
      }
    });
  });

  group('password', () {
    test('requires at least six characters', () {
      expect(v.password('secret'), isNull);
      expect(v.password('12345'), english.passwordTooShort);
      expect(v.password(null), english.enterPassword);
    });

    test('counts spaces, since they are legal in a password', () {
      expect(v.password('      '), english.enterPassword, reason: 'all blank');
      expect(v.password('a b c d'), isNull);
    });
  });

  test('confirmPassword only passes on an exact match', () {
    expect(v.confirmPassword('secret', 'secret'), isNull);
    expect(v.confirmPassword('secret', 'Secret'), english.passwordsMismatch);
    expect(v.confirmPassword('', 'secret'), english.enterConfirmPassword);
  });

  test('name only needs to be non-blank', () {
    expect(v.name('Ahmed'), isNull);
    expect(v.name('   '), english.enterName);
    expect(v.name(null), english.enterName);
  });

  test('phone rejects anything too short to dial', () {
    expect(v.phone('01001234567'), isNull);
    expect(v.phone('123'), english.invalidPhone);
    expect(v.phone(''), english.enterPhone);
  });

  group('language', () {
    final ar = Validators(arabic);

    test('the same mistake gets a different message in Arabic', () {
      expect(ar.email('abc'), arabic.invalidEmail);
      expect(ar.email('abc'), isNot(english.invalidEmail));
      expect(ar.password('1'), arabic.passwordTooShort);
      expect(ar.confirmPassword('a', 'b'), arabic.passwordsMismatch);
    });

    test('valid input passes in every language', () {
      expect(ar.email('ahmed@example.com'), isNull);
      expect(ar.password('secret'), isNull);
      expect(ar.phone('01001234567'), isNull);
    });
  });
}
