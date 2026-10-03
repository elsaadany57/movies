import 'package:flutter/widgets.dart';

final _letter = RegExp(r'\p{L}', unicode: true);

/// Whether [rune] belongs to a right-to-left script (Arabic, Hebrew and the
/// presentation forms of Arabic).
bool _isRtlLetter(int rune) =>
    (rune >= 0x0590 && rune <= 0x08FF) ||
    (rune >= 0xFB1D && rune <= 0xFDFF) ||
    (rune >= 0xFE70 && rune <= 0xFEFF);

/// Which way a piece of content should run, judged by its first letter rather
/// than by the language the app is in.
///
/// The movie data comes from an English-only API, so its summary and titles
/// are English even when the app is in Arabic. Laid out right to left they
/// would be flush right with their full stops stranded on the wrong side, so
/// they take the direction of their own script. Text with no letters yet
/// (digits, punctuation, empty) follows the surrounding direction.
TextDirection contentDirection(BuildContext context, String text) {
  for (final rune in text.runes) {
    if (!_letter.hasMatch(String.fromCharCode(rune))) continue;
    return _isRtlLetter(rune) ? TextDirection.rtl : TextDirection.ltr;
  }
  return Directionality.of(context);
}
