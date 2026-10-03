import '../models/movie.dart';
import '../services/library_service.dart';

/// The user's saved movies. ViewModels talk to this, never to Firestore.
class LibraryRepository {
  LibraryRepository(this._service);

  final LibraryService _service;

  Future<List<Movie>> getWatchList() => _fetch(LibraryService.watchList);

  Future<List<Movie>> getHistory() => _fetch(LibraryService.history);

  Future<void> addToWatchList(Movie movie) {
    return _service.add(LibraryService.watchList, movie.toJson());
  }

  Future<void> removeFromWatchList(int movieId) {
    return _service.remove(LibraryService.watchList, movieId);
  }

  Future<void> addToHistory(Movie movie) {
    return _service.add(LibraryService.history, movie.toJson());
  }

  Future<List<Movie>> _fetch(String name) async {
    final json = await _service.fetch(name);
    return json.map(Movie.fromJson).toList();
  }
}
