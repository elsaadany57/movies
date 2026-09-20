import '../models/movie.dart';
import '../services/movie_service.dart';

/// Single source of truth for movie data. ViewModels only talk to this,
/// never to the service directly. Add caching / local DB here later.
class MovieRepository {
  MovieRepository(this._service);

  final MovieService _service;

  Future<List<Movie>> getMovies({
    String? genre,
    String? queryTerm,
    int limit = 20,
    int page = 1,
    String sortBy = 'date_added',
    int minimumRating = 0,
  }) async {
    final json = await _service.listMovies(
      genre: genre,
      queryTerm: queryTerm,
      limit: limit,
      page: page,
      sortBy: sortBy,
      minimumRating: minimumRating,
    );
    return json.map(Movie.fromJson).toList();
  }

  Future<Movie> getMovieDetails(int id) async {
    return Movie.fromJson(await _service.movieDetails(id));
  }

  Future<List<Movie>> getSuggestions(int id) async {
    final json = await _service.suggestions(id);
    return json.map(Movie.fromJson).toList();
  }
}
