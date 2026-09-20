import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/app.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';
import 'package:movies_app/data/services/movie_service.dart';
import 'package:movies_app/features/movies/view_models/movies_view_model.dart';
import 'package:movies_app/features/auth/views/login_screen.dart';
import 'package:movies_app/features/onboarding/views/onboarding_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('splash -> onboarding -> login', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => MoviesViewModel(MovieRepository(MovieService())),
        child: const MoviesApp(),
      ),
    );

    // Splash lingers, then fades into onboarding.
    expect(find.byType(OnboardingScreen), findsNothing);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);

    // Intro -> Discover (no Back) -> Genres -> Watchlists -> Rate -> Finish.
    expect(find.text('Explore Now'), findsOneWidget);
    await tester.tap(find.text('Explore Now'));
    await tester.pumpAndSettle();

    expect(find.text('Discover Movies'), findsOneWidget);
    expect(find.text('Back'), findsNothing);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Explore All Genres'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Discover Movies'), findsOneWidget);

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Start Watching Now'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
