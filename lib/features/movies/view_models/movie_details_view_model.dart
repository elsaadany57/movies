import 'package:flutter/foundation.dart';

import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../core/errors/load_error.dart';

/// Loads one movie plus the API's four suggestions for it.
class MovieDetailsViewModel extends ChangeNotifier {
  MovieDetailsViewModel(this._repository);

  final MovieRepository _repository;

  Movie? _movie;
  List<Movie> _suggestions = [];
  bool _isLoading = false;
  LoadError? _error;

  Movie? get movie => _movie;
  List<Movie> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  LoadError? get error => _error;

  Future<void> load(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getMovieDetails(id),
        _repository.getSuggestions(id),
      ]);
      _movie = results[0] as Movie;
      _suggestions = results[1] as List<Movie>;
    } catch (_) {
      _error = LoadError.movie;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
