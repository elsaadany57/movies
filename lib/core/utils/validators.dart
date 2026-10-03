import '../localization/l10n.dart';

/// Form validators shared by the auth and profile screens. Built from the
/// current translations, so each message follows the language the app is in:
///
/// ```dart
/// final validators = Validators(context.l10n);
/// AuthTextField(validator: validators.email);
/// ```
class Validators {
  const Validators(this._l10n);

  final AppLocalizations _l10n;

  static final _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static const _minPasswordLength = 6;
  static const _minPhoneLength = 7;

  static bool _blank(String? value) => value == null || value.trim().isEmpty;

  String? name(String? value) => _blank(value) ? _l10n.enterName : null;

  String? email(String? value) {
    if (_blank(value)) return _l10n.enterEmail;
    return _email.hasMatch(value!.trim()) ? null : _l10n.invalidEmail;
  }

  String? password(String? value) {
    if (_blank(value)) return _l10n.enterPassword;
    return value!.length < _minPasswordLength ? _l10n.passwordTooShort : null;
  }

  String? confirmPassword(String? value, String password) {
    if (_blank(value)) return _l10n.enterConfirmPassword;
    return value == password ? null : _l10n.passwordsMismatch;
  }

  String? phone(String? value) {
    if (_blank(value)) return _l10n.enterPhone;
    return value!.trim().length < _minPhoneLength ? _l10n.invalidPhone : null;
  }
}
