/// Form validators shared by the auth screens.
class Validators {
  static final _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? required(String? value, String field) =>
      (value == null || value.trim().isEmpty) ? 'Enter your $field' : null;

  static String? email(String? value) {
    final empty = required(value, 'email');
    if (empty != null) return empty;
    return _email.hasMatch(value!.trim()) ? null : 'Enter a valid email';
  }

  static String? password(String? value) {
    final empty = required(value, 'password');
    if (empty != null) return empty;
    return value!.length < 6 ? 'Password must be at least 6 characters' : null;
  }

  static String? confirmPassword(String? value, String password) {
    final empty = required(value, 'password confirmation');
    if (empty != null) return empty;
    return value == password ? null : 'Passwords do not match';
  }

  static String? phone(String? value) {
    final empty = required(value, 'phone number');
    if (empty != null) return empty;
    return value!.trim().length < 7 ? 'Enter a valid phone number' : null;
  }
}
