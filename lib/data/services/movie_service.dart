import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';

/// Talks to the YTS API. Returns raw JSON maps; the repository turns them
/// into models.
class MovieService {
  MovieService({Dio? dio}) : _dio = dio ?? createDio();

  final Dio _dio;

  Future<List<Map<String, dynamic>>> listMovies({
    String? genre,
    String? queryTerm,
    int limit = 20,
    int page = 1,
    String sortBy = 'date_added',
    int minimumRating = 0,
  }) async {
    final data = await _get(ApiConstants.listMovies, {
      'limit': limit,
      'page': page,
      'sort_by': sortBy,
      if (minimumRating > 0) 'minimum_rating': minimumRating,
      'genre': ?genre,
      if (queryTerm != null && queryTerm.isNotEmpty) 'query_term': queryTerm,
    });

    // `movies` is absent rather than empty when nothing matches.
    final movies = data['movies'] as List?;
    return movies?.cast<Map<String, dynamic>>() ?? const [];
  }

  Future<Map<String, dynamic>> movieDetails(int id) async {
    final data = await _get(ApiConstants.movieDetails, {
      'movie_id': id,
      'with_images': true,
      'with_cast': true,
    });
    return data['movie'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> suggestions(int id) async {
    final data = await _get(ApiConstants.movieSuggestions, {'movie_id': id});
    final movies = data['movies'] as List?;
    return movies?.cast<Map<String, dynamic>>() ?? const [];
  }

  /// Unwraps the `{status, status_message, data}` envelope every endpoint uses.
  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, dynamic> query,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: query,
    );

    final body = response.data;
    if (body == null || body['status'] != 'ok') {
      throw MovieApiException(
        (body?['status_message'] as String?) ?? 'Request failed',
      );
    }

    return (body['data'] as Map).cast<String, dynamic>();
  }
}

class MovieApiException implements Exception {
  const MovieApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
