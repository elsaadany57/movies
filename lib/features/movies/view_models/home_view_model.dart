import 'package:flutter/foundation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../core/errors/load_error.dart';

/// One horizontal row on the home screen.
class GenreRow {
  const GenreRow(this.genre, this.movies);

  final String genre;
  final List<Movie> movies;
}

/// Holds UI state for the home screen: the featured carousel plus one row
/// per genre. No widgets in here.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);

  final MovieRepository _repository;

  List<Movie> _featured = [];
  List<GenreRow> _rows = [];
  bool _isLoading = false;
  LoadError? _error;

  List<Movie> get featured => _featured;
  List<GenreRow> get rows => _rows;
  bool get isLoading => _isLoading;
  LoadError? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // The rows are independent, so fetch them together rather than in turn.
      final results = await Future.wait([
        _repository.getMovies(limit: 10, sortBy: 'download_count'),
        for (final genre in ApiConstants.homeGenres)
          _repository.getMovies(genre: genre, limit: 10),
      ]);

      _featured = results.first;
      _rows = [
        for (var i = 0; i < ApiConstants.homeGenres.length; i++)
          if (results[i + 1].isNotEmpty)
            GenreRow(ApiConstants.homeGenres[i], results[i + 1]),
      ];
    } catch (_) {
      _error = LoadError.movies;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
