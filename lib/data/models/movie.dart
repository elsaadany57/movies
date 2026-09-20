class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterUrl;
  final double rating;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterUrl,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String? ?? '',
      posterUrl: json['poster_path'] as String?,
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
    );
  }
}
