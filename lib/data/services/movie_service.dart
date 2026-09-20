/// Talks to the outside world (HTTP API). Returns raw JSON only.
/// Replace the fake data with a real call (e.g. TMDB) when you're ready.
class MovieService {
  Future<List<Map<String, dynamic>>> fetchPopularMovies() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return [
      {
        'id': 1,
        'title': 'Inception',
        'overview': 'A thief who steals secrets through dreams.',
        'poster_path': null,
        'vote_average': 8.8,
      },
      {
        'id': 2,
        'title': 'Interstellar',
        'overview': 'Explorers travel through a wormhole in space.',
        'poster_path': null,
        'vote_average': 8.6,
      },
    ];
  }
}
