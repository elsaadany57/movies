import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/data/models/app_user.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';
import 'package:movies_app/features/movies/views/movie_details_screen.dart';
import 'package:movies_app/features/movies/widgets/movie_poster_card.dart';
import 'package:movies_app/features/profile/view_models/library_view_model.dart';
import 'package:movies_app/features/profile/view_models/profile_view_model.dart';
import 'package:movies_app/features/profile/views/profile_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/fakes.dart';

void _phoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  group('movie details', () {
    late FakeLibraryRepository repository;
    late LibraryViewModel library;

    Future<void> openDetails(WidgetTester tester) async {
      _phoneScreen(tester);
      repository = FakeLibraryRepository();
      library = LibraryViewModel(repository);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<MovieRepository>.value(value: FakeMovieRepository()),
            ChangeNotifierProvider.value(value: library),
          ],
          child: const MaterialApp(home: MovieDetailsScreen(movieId: 7)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('the bookmark saves the movie, then un-saves it', (tester) async {
      await openDetails(tester);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      expect(library.isSaved(7), isTrue);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.text('Added to your Watch List'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

      expect(library.isSaved(7), isFalse);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.text('Removed from your Watch List'), findsOneWidget);
    });

    testWidgets('a failed save reports it and leaves the bookmark empty',
        (tester) async {
      await openDetails(tester);
      repository.failing = true;

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      expect(library.isSaved(7), isFalse);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.text('Could not update your Watch List'), findsOneWidget);
    });

    testWidgets('the Watch button adds the movie to history', (tester) async {
      await openDetails(tester);
      expect(library.history, isEmpty, reason: 'merely opening it is not watching');

      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      expect(library.history.single.id, 7);
      expect(find.text('Added to your History'), findsOneWidget);
      expect(library.watchList, isEmpty, reason: 'history is separate');
    });

    testWidgets('the play circle over the artwork does the same', (tester) async {
      await openDetails(tester);

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();

      expect(library.history.single.id, 7);
    });
  });

  group('profile', () {
    Future<LibraryViewModel> openProfile(
      WidgetTester tester, {
      required FakeLibraryRepository repository,
    }) async {
      _phoneScreen(tester);
      final library = LibraryViewModel(repository);
      final auth = FakeAuthRepository()
        ..profile = const AppUser(
          uid: 'u1',
          name: 'Ahmed',
          email: 'a@b.com',
          phone: '0100',
          avatar: 0,
        );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: library),
            ChangeNotifierProvider(
              create: (_) => ProfileViewModel(auth, library),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: ProfileScreen())),
        ),
      );
      await library.load();
      await tester.pumpAndSettle();
      return library;
    }

    testWidgets('shows the real counts and the watch list posters',
        (tester) async {
      await openProfile(
        tester,
        repository: FakeLibraryRepository(
          watchList: [fakeMovie(1), fakeMovie(2), fakeMovie(3)],
          history: [fakeMovie(9)],
        ),
      );

      expect(find.text('3'), findsOneWidget, reason: 'wish list count');
      expect(find.text('1'), findsOneWidget, reason: 'history count');
      expect(find.byType(MoviePosterCard), findsNWidgets(3));
    });

    testWidgets('the History tab shows what was watched', (tester) async {
      await openProfile(
        tester,
        repository: FakeLibraryRepository(
          watchList: [fakeMovie(1)],
          history: [fakeMovie(8), fakeMovie(9)],
        ),
      );

      await tester.tap(find.textContaining('History').last);
      await tester.pumpAndSettle();

      final shown = tester
          .widgetList<MoviePosterCard>(find.byType(MoviePosterCard))
          .map((card) => card.movie.id);
      expect(shown, containsAll([8, 9]));
      expect(shown, isNot(contains(1)), reason: 'not the watch list');
    });

    testWidgets('empty lists fall back to the empty state, not a blank grid',
        (tester) async {
      await openProfile(tester, repository: FakeLibraryRepository());

      expect(find.byType(MoviePosterCard), findsNothing);
      expect(find.text('Nothing here yet'), findsOneWidget);
    });

    testWidgets('a load failure offers a retry', (tester) async {
      final repository = FakeLibraryRepository()..failingReads = true;
      final library = await openProfile(tester, repository: repository);

      expect(library.hasError, isTrue);
      expect(find.text('Could not load your movies'), findsOneWidget);

      repository
        ..failingReads = false
        ..stored['watchlist'] = [fakeMovie(4)];
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byType(MoviePosterCard), findsOneWidget);
    });
  });
}
