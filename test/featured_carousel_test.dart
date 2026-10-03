import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/movies/widgets/featured_carousel.dart';
import 'package:movies_app/features/movies/widgets/movie_poster_card.dart';

import 'helpers/fakes.dart';

Future<void> _pump(WidgetTester tester, int count) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            FeaturedCarousel(movies: [for (var i = 1; i <= count; i++) fakeMovie(i)]),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Ids of the posters that actually show on screen, left to right.
List<int> _visibleIds(WidgetTester tester) {
  const screenWidth = 430.0;
  final cards = tester.widgetList<MoviePosterCard>(find.byType(MoviePosterCard));

  final visible = [
    for (final card in cards)
      if (tester.getRect(find.byWidget(card)).right > 0 &&
          tester.getRect(find.byWidget(card)).left < screenWidth)
        card,
  ]..sort((a, b) => tester
      .getCenter(find.byWidget(a))
      .dx
      .compareTo(tester.getCenter(find.byWidget(b)).dx));

  return [for (final card in visible) card.movie.id];
}

void main() {
  testWidgets('the first poster has a neighbour on each side', (tester) async {
    await _pump(tester, 5);

    // 1 is centred; 5 wraps round to its left and 2 sits on its right.
    expect(_visibleIds(tester), [5, 1, 2]);
  });

  testWidgets('swiping moves the centre on and keeps both neighbours',
      (tester) async {
    await _pump(tester, 5);

    await tester.drag(find.byType(PageView), const Offset(-232, 0));
    await tester.pumpAndSettle();

    expect(_visibleIds(tester), [1, 2, 3]);
  });

  testWidgets('swiping back from the first poster wraps to the last',
      (tester) async {
    await _pump(tester, 5);

    await tester.drag(find.byType(PageView), const Offset(232, 0));
    await tester.pumpAndSettle();

    expect(_visibleIds(tester), [4, 5, 1]);
  });

  testWidgets('a list too short to loop does not repeat posters',
      (tester) async {
    await _pump(tester, 2);

    final ids = _visibleIds(tester);
    expect(ids.toSet().length, ids.length, reason: 'no poster shown twice');
    expect(ids, [1, 2]);
  });
}
