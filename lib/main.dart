import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/movie_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/movie_service.dart';
import 'features/auth/view_models/auth_view_model.dart';
import 'features/movies/view_models/browse_view_model.dart';
import 'features/movies/view_models/home_view_model.dart';
import 'features/movies/view_models/search_view_model.dart';
import 'features/profile/view_models/profile_view_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Dependency wiring: Service -> Repository -> ViewModel -> View
  final movieRepository = MovieRepository(MovieService());
  final authRepository = AuthRepository(AuthService());

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: movieRepository),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(movieRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(movieRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => BrowseViewModel(movieRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepository),
        ),
      ],
      child: const MoviesApp(),
    ),
  );
}
