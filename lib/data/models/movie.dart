/// A movie as the YTS API returns it. The list and details endpoints share
/// most fields, so one model covers both; the details-only ones stay null
/// until [MovieService.movieDetails] fills them.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    required this.summary,
    required this.coverUrl,
    required this.backgroundUrl,
    this.likeCount,
    this.trailerCode,
    this.screenshots = const [],
  });

  final int id;
  final String title;
  final int year;
  final double rating;

  /// Minutes. The API returns 0 when it does not know.
  final int runtime;
  final List<String> genres;
  final String summary;
  final String coverUrl;
  final String backgroundUrl;

  /// Details endpoint only.
  final int? likeCount;
  final String? trailerCode;
  final List<String> screenshots;

  bool get hasTrailer => (trailerCode ?? '').isNotEmpty;

  factory Movie.fromJson(Map<String, dynamic> json) {
    // The list endpoint calls it `summary`, the details endpoint
    // `description_full` / `description_intro`.
    final summary = (json['summary'] ??
            json['description_full'] ??
            json['description_intro'] ??
            '') as String;

    return Movie(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      genres: (json['genres'] as List?)?.cast<String>() ?? const [],
      summary: summary,
      coverUrl: (json['medium_cover_image'] as String?) ??
          (json['large_cover_image'] as String?) ??
          '',
      backgroundUrl: (json['background_image_original'] as String?) ??
          (json['background_image'] as String?) ??
          '',
      likeCount: (json['like_count'] as num?)?.toInt(),
      trailerCode: json['yt_trailer_code'] as String?,
      screenshots: [
        for (final key in const [
          'medium_screenshot_image1',
          'medium_screenshot_image2',
          'medium_screenshot_image3',
        ])
          if (json[key] is String && (json[key] as String).isNotEmpty)
            json[key] as String,
      ],
    );
  }
}
