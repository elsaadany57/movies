class ApiConstants {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  /// Passed at build time so the key never lands in git:
  /// flutter run --dart-define=TMDB_API_KEY=your_key
  static const apiKey = String.fromEnvironment('TMDB_API_KEY');
}
