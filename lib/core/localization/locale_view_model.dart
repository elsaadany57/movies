import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which language the app is in, remembered between launches.
///
/// With nothing saved it follows the phone's language, falling back to
/// English if the app does not speak it.
class LocaleViewModel extends ChangeNotifier {
  LocaleViewModel(this._prefs, {Locale? deviceLocale})
      : _locale = _initial(_prefs, deviceLocale);

  static const english = Locale('en');
  static const arabic = Locale('ar');
  static const supported = [english, arabic];

  static const _key = 'languageCode';

  final SharedPreferences _prefs;
  Locale _locale;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == arabic.languageCode;

  static Locale _initial(SharedPreferences prefs, Locale? device) {
    final saved = prefs.getString(_key);
    return _match(saved) ?? _match(device?.languageCode) ?? english;
  }

  static Locale? _match(String? languageCode) {
    for (final locale in supported) {
      if (locale.languageCode == languageCode) return locale;
    }
    return null;
  }

  Future<void> setLocale(Locale locale) async {
    final match = _match(locale.languageCode);
    if (match == null || match == _locale) return;

    _locale = match;
    notifyListeners();
    await _prefs.setString(_key, match.languageCode);
  }

  Future<void> toggle() => setLocale(isArabic ? english : arabic);
}
