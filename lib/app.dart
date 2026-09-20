import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/movies/views/movies_screen.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const MoviesScreen(),
    );
  }
}
