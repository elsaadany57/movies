import 'package:flutter/foundation.dart';

import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';

/// Holds UI state + logic for the movies screen. No widgets in here.
class MoviesViewModel extends ChangeNotifier {
  MoviesViewModel(this._repository);

  final MovieRepository _repository;

  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _error;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movies = await _repository.getPopularMovies();
    } catch (e) {
      _error = 'Could not load movies';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
