import 'package:flutter/foundation.dart';

import '../../../data/models/movie.dart';
import '../../../data/repositories/library_repository.dart';

/// The signed-in user's watch list and history. App-wide rather than tied to
/// the profile screen, because the details screen needs it too: to show
/// whether a movie is saved, and to record that it was watched.
class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel(this._repository);

  final LibraryRepository _repository;

  List<Movie> _watchList = [];
  List<Movie> _history = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<Movie> get watchList => _watchList;
  List<Movie> get history => _history;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  bool isSaved(int movieId) => _watchList.any((m) => m.id == movieId);

  Future<void> load() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getWatchList(),
        _repository.getHistory(),
      ]);
      _watchList = results[0];
      _history = results[1];
    } catch (_) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves or un-saves [movie]. Returns whether it is saved afterwards, or
  /// null if the change could not be stored (in which case nothing changed).
  Future<bool?> toggleWatchList(Movie movie) async {
    final saving = !isSaved(movie.id);
    final before = _watchList;

    // Update first so the bookmark responds instantly, undo if it fails.
    _watchList = saving
        ? [movie, ...before]
        : before.where((m) => m.id != movie.id).toList();
    notifyListeners();

    try {
      if (saving) {
        await _repository.addToWatchList(movie);
      } else {
        await _repository.removeFromWatchList(movie.id);
      }
      return saving;
    } catch (_) {
      _watchList = before;
      notifyListeners();
      return null;
    }
  }

  /// Records that [movie] was watched. Watching it again moves it back to
  /// the top rather than listing it twice.
  Future<void> addToHistory(Movie movie) async {
    _history = [movie, ..._history.where((m) => m.id != movie.id)];
    notifyListeners();

    try {
      await _repository.addToHistory(movie);
    } catch (_) {
      // Best effort: the entry still shows this session, and the next load
      // reconciles with what was actually stored.
    }
  }

  /// Forgets everything held for the previous account on sign-out.
  void clear() {
    _watchList = [];
    _history = [];
    _hasError = false;
    notifyListeners();
  }
}
