import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/utils/content_direction.dart';

/// Runs [text] through the helper inside an app whose own direction is [app].
Future<TextDirection> _direction(
  WidgetTester tester,
  String text, {
  TextDirection app = TextDirection.rtl,
}) async {
  late TextDirection result;
  await tester.pumpWidget(
    Directionality(
      textDirection: app,
      child: Builder(builder: (context) {
        result = contentDirection(context, text);
        return const SizedBox();
      }),
    ),
  );
  return result;
}

void main() {
  testWidgets('English reads left to right even on an Arabic screen', (tester) async {
    expect(await _direction(tester, 'Fed up with their lives.'), TextDirection.ltr);
  });

  testWidgets('Arabic reads right to left even on an English screen', (tester) async {
    expect(
      await _direction(tester, 'اعثر على فيلمك', app: TextDirection.ltr),
      TextDirection.rtl,
    );
  });

  testWidgets('Hebrew counts as right to left too', (tester) async {
    expect(await _direction(tester, 'שלום', app: TextDirection.ltr), TextDirection.rtl);
  });

  testWidgets('the first letter decides, so leading digits and symbols are skipped',
      (tester) async {
    expect(await _direction(tester, '12 Angry Men'), TextDirection.ltr);
    expect(await _direction(tester, '"... مرحبا'), TextDirection.rtl);
    expect(await _direction(tester, '2012: Doomsday'), TextDirection.ltr);
  });

  testWidgets('a mixed title follows whichever script comes first', (tester) async {
    expect(await _direction(tester, 'Avengers: أبطال'), TextDirection.ltr);
    expect(await _direction(tester, 'أبطال Avengers'), TextDirection.rtl);
  });

  testWidgets('text with no letters yet follows the surrounding direction',
      (tester) async {
    expect(await _direction(tester, ''), TextDirection.rtl);
    expect(await _direction(tester, '2024'), TextDirection.rtl);
    expect(await _direction(tester, '...', app: TextDirection.ltr), TextDirection.ltr);
  });
}
