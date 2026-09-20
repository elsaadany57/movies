import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/movie_repository.dart';
import 'data/services/movie_service.dart';
import 'features/movies/view_models/movies_view_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Dependency wiring: Service -> Repository -> ViewModel -> View
  final movieRepository = MovieRepository(MovieService());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesViewModel(movieRepository),
        ),
      ],
      child: const MoviesApp(),
    ),
  );
}
