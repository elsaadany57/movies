import '../models/movie.dart';
import '../services/movie_service.dart';

/// Single source of truth for movie data. ViewModels only talk to this,
/// never to the service directly. Add caching / local DB here later.
class MovieRepository {
  MovieRepository(this._service);

  final MovieService _service;

  Future<List<Movie>> getPopularMovies() async {
    final json = await _service.fetchPopularMovies();
    return json.map(Movie.fromJson).toList();
  }
}
