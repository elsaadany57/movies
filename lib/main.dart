import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/localization/locale_view_model.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/library_repository.dart';
import 'data/repositories/movie_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/library_service.dart';
import 'data/services/movie_service.dart';
import 'features/auth/view_models/auth_view_model.dart';
import 'features/movies/view_models/browse_view_model.dart';
import 'features/movies/view_models/home_view_model.dart';
import 'features/movies/view_models/search_view_model.dart';
import 'features/profile/view_models/library_view_model.dart';
import 'features/profile/view_models/profile_view_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localeViewModel = LocaleViewModel(
    await SharedPreferences.getInstance(),
    deviceLocale: PlatformDispatcher.instance.locale,
  );

  // Dependency wiring: Service -> Repository -> ViewModel -> View
  final movieRepository = MovieRepository(MovieService());
  final authService = AuthService();
  final authRepository = AuthRepository(authService);
  final libraryViewModel = LibraryViewModel(
    LibraryRepository(LibraryService(authService)),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeViewModel),
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
        ChangeNotifierProvider.value(value: libraryViewModel),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(authRepository, libraryViewModel),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepository),
        ),
      ],
      child: const MoviesApp(),
    ),
  );
}
