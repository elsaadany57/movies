import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';

/// Backs the search tab. Queries are debounced so typing does not fire a
/// request per keystroke, which the API docs ask callers to avoid.
class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._repository);

  final MovieRepository _repository;

  static const _debounce = Duration(milliseconds: 450);

  Timer? _timer;
  String _term = '';
  List<Movie> _results = [];
  bool _isLoading = false;
  String? _error;

  String get term => _term;
  List<Movie> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmptyTerm => _term.trim().isEmpty;

  void onTermChanged(String value) {
    _term = value;
    _timer?.cancel();

    if (isEmptyTerm) {
      _results = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _timer = Timer(_debounce, search);
    notifyListeners();
  }

  Future<void> search() async {
    if (isEmptyTerm) return;
    final term = _term;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _repository.getMovies(queryTerm: term, limit: 20);
      // A slower earlier request must not overwrite a newer term's results.
      if (term != _term) return;
      _results = results;
    } catch (_) {
      if (term != _term) return;
      _error = 'Could not search right now';
    } finally {
      if (term == _term) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
