import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/localization/l10n.dart';

/// Why an auth request failed, in terms the user can act on. Firebase's own
/// error codes are mapped here once, and worded by the screen so the message
/// follows the current language.
enum AuthFailure {
  invalidEmail,
  userDisabled,
  wrongCredentials,
  emailInUse,
  weakPassword,
  noInternet,
  tooManyRequests,
  notAllowed,
  unknown;

  factory AuthFailure.fromCode(String code) => switch (code) {
        'invalid-email' => invalidEmail,
        'user-disabled' => userDisabled,
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          wrongCredentials,
        'email-already-in-use' => emailInUse,
        'weak-password' => weakPassword,
        'network-request-failed' => noInternet,
        'too-many-requests' => tooManyRequests,
        'operation-not-allowed' => notAllowed,
        _ => unknown,
      };

  factory AuthFailure.fromException(FirebaseAuthException e) =>
      AuthFailure.fromCode(e.code);

  String message(AppLocalizations l10n) => switch (this) {
        invalidEmail => l10n.authInvalidEmail,
        userDisabled => l10n.authUserDisabled,
        wrongCredentials => l10n.authWrongCredentials,
        emailInUse => l10n.authEmailInUse,
        weakPassword => l10n.authWeakPassword,
        noInternet => l10n.authNoInternet,
        tooManyRequests => l10n.authTooManyRequests,
        notAllowed => l10n.authNotAllowed,
        unknown => l10n.somethingWentWrong,
      };
}
