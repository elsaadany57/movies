/// The YTS API (https://yts.gg/api). No key is required; the docs ask that
/// callers cache responses and keep request rates reasonable.
class ApiConstants {
  static const baseUrl = 'https://movies-api.accel.li/api/v2';

  static const listMovies = '/list_movies.json';
  static const movieDetails = '/movie_details.json';
  static const movieSuggestions = '/movie_suggestions.json';

  /// Genres the home screen shows a row for, in order.
  static const homeGenres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Drama',
    'Horror',
  ];
}
