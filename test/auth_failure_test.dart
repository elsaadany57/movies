import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/errors/load_error.dart';
import 'package:movies_app/core/localization/genre_labels.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/features/auth/models/auth_failure.dart';

void main() {
  final english = lookupAppLocalizations(const Locale('en'));
  final arabic = lookupAppLocalizations(const Locale('ar'));

  group('AuthFailure', () {
    test('maps the Firebase codes the app expects', () {
      expect(AuthFailure.fromCode('invalid-email'), AuthFailure.invalidEmail);
      expect(AuthFailure.fromCode('user-disabled'), AuthFailure.userDisabled);
      expect(AuthFailure.fromCode('email-already-in-use'), AuthFailure.emailInUse);
      expect(AuthFailure.fromCode('weak-password'), AuthFailure.weakPassword);
      expect(AuthFailure.fromCode('network-request-failed'), AuthFailure.noInternet);
      expect(AuthFailure.fromCode('too-many-requests'), AuthFailure.tooManyRequests);
      expect(AuthFailure.fromCode('operation-not-allowed'), AuthFailure.notAllowed);
    });

    test('treats every wrong-credential code alike, so nothing leaks which', () {
      for (final code in ['user-not-found', 'wrong-password', 'invalid-credential']) {
        expect(AuthFailure.fromCode(code), AuthFailure.wrongCredentials, reason: code);
      }
    });

    test('an unrecognised code becomes the generic failure', () {
      expect(AuthFailure.fromCode('something-new'), AuthFailure.unknown);
    });

    test('every failure has a message in both languages', () {
      for (final failure in AuthFailure.values) {
        expect(failure.message(english), isNotEmpty, reason: '$failure en');
        expect(failure.message(arabic), isNotEmpty, reason: '$failure ar');
        expect(failure.message(arabic), isNot(failure.message(english)),
            reason: '$failure should differ between languages');
      }
    });

    test('the messages say what they are meant to', () {
      expect(AuthFailure.wrongCredentials.message(english), 'Wrong email or password.');
      expect(AuthFailure.noInternet.message(english), 'No internet connection.');
    });
  });

  group('LoadError', () {
    test('every kind has a message in both languages', () {
      for (final error in LoadError.values) {
        expect(error.message(english), isNotEmpty, reason: '$error en');
        expect(error.message(arabic), isNotEmpty, reason: '$error ar');
      }
    });
  });

  group('genreLabel', () {
    test('translates every genre the app offers', () {
      const genres = [
        'Action', 'Adventure', 'Animation', 'Biography', 'Comedy', 'Crime',
        'Documentary', 'Drama', 'Family', 'Fantasy', 'History', 'Horror',
        'Music', 'Mystery', 'Romance', 'Sci-Fi', 'Sport', 'Thriller', 'War',
        'Western',
      ];
      for (final genre in genres) {
        expect(genreLabel(english, genre), genre, reason: 'English is the API name');
        expect(genreLabel(arabic, genre), isNot(genre), reason: '$genre untranslated');
      }
    });

    test('shows an unfamiliar genre as the API spelled it', () {
      expect(genreLabel(arabic, 'Film-Noir'), 'Film-Noir');
    });
  });
}
