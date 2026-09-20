import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/movies_view_model.dart';
import '../widgets/movie_tile.dart';

/// The View: only renders state from the ViewModel and forwards user actions.
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesViewModel>().loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MoviesViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: () {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.error != null) {
          return Center(child: Text(vm.error!));
        }
        return ListView.builder(
          itemCount: vm.movies.length,
          itemBuilder: (_, i) => MovieTile(movie: vm.movies[i]),
        );
      }(),
    );
  }
}
