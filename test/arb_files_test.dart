import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The generated code quietly falls back to English for a key missing from
/// the Arabic file, so a forgotten translation would ship unnoticed. These
/// read the files directly to catch that.
Map<String, dynamic> _load(String name) =>
    jsonDecode(File('lib/l10n/$name.arb').readAsStringSync())
        as Map<String, dynamic>;

Map<String, String> _strings(Map<String, dynamic> arb) => {
      for (final entry in arb.entries)
        if (!entry.key.startsWith('@')) entry.key: entry.value as String,
    };

Set<String> _placeholders(String text) =>
    RegExp(r'\{(\w+)\}').allMatches(text).map((m) => m.group(1)!).toSet();

void main() {
  final english = _strings(_load('app_en'));
  final arabic = _strings(_load('app_ar'));

  test('Arabic has every key English has, and nothing extra', () {
    expect(
      english.keys.toSet().difference(arabic.keys.toSet()),
      isEmpty,
      reason: 'untranslated into Arabic',
    );
    expect(
      arabic.keys.toSet().difference(english.keys.toSet()),
      isEmpty,
      reason: 'in Arabic but not in the English template',
    );
  });

  test('no translation is blank', () {
    for (final map in [english, arabic]) {
      for (final entry in map.entries) {
        if (entry.key == '@@locale') continue;
        expect(entry.value.trim(), isNotEmpty, reason: entry.key);
      }
    }
  });

  test('each Arabic string uses exactly the placeholders English does', () {
    for (final key in english.keys) {
      if (key == '@@locale') continue;
      expect(
        _placeholders(arabic[key]!),
        _placeholders(english[key]!),
        reason: '$key would crash or print a raw {name}',
      );
    }
  });

  test('every placeholder is declared in the English template', () {
    final arb = _load('app_en');
    for (final key in english.keys) {
      final used = _placeholders(english[key]!);
      if (used.isEmpty) continue;

      final declared =
          ((arb['@$key'] as Map?)?['placeholders'] as Map?)?.keys.toSet();
      expect(declared, used, reason: key);
    }
  });

  test('Arabic strings are actually Arabic, not pasted English', () {
    final arabicLetters = RegExp(r'[؀-ۿ]');
    for (final entry in arabic.entries) {
      if (entry.key == '@@locale') continue;
      expect(arabicLetters.hasMatch(entry.value), isTrue, reason: entry.key);
    }
  });
}
