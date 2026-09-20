import 'package:flutter/foundation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';

/// Backs the browse tab: one genre selected at a time, its movies below.
class BrowseViewModel extends ChangeNotifier {
  BrowseViewModel(this._repository);

  final MovieRepository _repository;

  static const genres = ApiConstants.browseGenres;

  String _genre = genres.first;
  List<Movie> _movies = [];
  bool _isLoading = false;
  String? _error;

  String get genre => _genre;
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void selectGenre(String genre) {
    if (genre == _genre) return;
    _genre = genre;
    load();
  }

  Future<void> load() async {
    final genre = _genre;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final movies = await _repository.getMovies(genre: genre, limit: 20);
      // Ignore a slow response for a genre the user has moved on from.
      if (genre != _genre) return;
      _movies = movies;
    } catch (_) {
      if (genre != _genre) return;
      _error = 'Could not load $genre movies';
    } finally {
      if (genre == _genre) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
