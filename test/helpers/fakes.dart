import 'package:movies_app/data/models/app_user.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/data/repositories/auth_repository.dart';
import 'package:movies_app/data/repositories/library_repository.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';
import 'package:movies_app/data/services/library_service.dart';

/// A movie with just enough filled in to draw a poster.
Movie fakeMovie(int id, {String? title, bool trailer = false}) => Movie(
      id: id,
      title: title ?? 'Movie $id',
      trailerCode: trailer ? 'abc123' : null,
      year: 2020,
      rating: 7.7,
      runtime: 100,
      genres: const ['Action'],
      summary: '',
      coverUrl: '',
      backgroundUrl: '',
    );

/// Stands in for the real repository so tests never touch Firebase.
class FakeAuthRepository implements AuthRepository {
  AppUser? profile;

  @override
  bool get isSignedIn => profile != null;

  @override
  Future<AppUser?> login(String email, String password) async => profile;

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int avatar,
  }) async {
    return profile = AppUser(
      uid: 'fake',
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
    );
  }

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async => profile = null;

  @override
  Future<AppUser?> currentProfile() async => profile;

  @override
  Future<void> updateProfile(AppUser user) async => profile = user;

  @override
  Future<void> deleteAccount() async => profile = null;
}

/// Keeps both lists in memory, newest first, like the real one would return.
/// Set [failing] to make every write throw.
class FakeLibraryRepository implements LibraryRepository {
  FakeLibraryRepository({
    List<Movie> watchList = const [],
    List<Movie> history = const [],
  })  : stored = {
          LibraryService.watchList: [...watchList],
          LibraryService.history: [...history],
        };

  final Map<String, List<Movie>> stored;
  bool failing = false;
  bool failingReads = false;
  int loads = 0;

  void _guard() {
    if (failing) throw Exception('offline');
  }

  void _put(String list, Movie movie) {
    _guard();
    stored[list] = [movie, ...stored[list]!.where((m) => m.id != movie.id)];
  }

  @override
  Future<List<Movie>> getWatchList() async {
    loads++;
    if (failingReads) throw Exception('offline');
    return [...stored[LibraryService.watchList]!];
  }

  @override
  Future<List<Movie>> getHistory() async {
    if (failingReads) throw Exception('offline');
    return [...stored[LibraryService.history]!];
  }

  @override
  Future<void> addToWatchList(Movie movie) async =>
      _put(LibraryService.watchList, movie);

  @override
  Future<void> removeFromWatchList(int movieId) async {
    _guard();
    stored[LibraryService.watchList]!.removeWhere((m) => m.id == movieId);
  }

  @override
  Future<void> addToHistory(Movie movie) async =>
      _put(LibraryService.history, movie);
}

/// Answers every movie request from memory, so screens render without a
/// network. Details always return a movie with a trailer.
class FakeMovieRepository implements MovieRepository {
  @override
  Future<Movie> getMovieDetails(int id) async => fakeMovie(id, trailer: true);

  @override
  Future<List<Movie>> getSuggestions(int id) async => [fakeMovie(id + 100)];

  @override
  Future<List<Movie>> getMovies({
    String? genre,
    String? queryTerm,
    int limit = 20,
    int page = 1,
    String sortBy = 'date_added',
    int minimumRating = 0,
  }) async =>
      [fakeMovie(1), fakeMovie(2)];
}
