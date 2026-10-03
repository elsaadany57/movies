import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';
import 'package:movies_app/data/services/movie_service.dart';
import 'package:movies_app/features/movies/view_models/search_view_model.dart';

/// Records every search and lets each test decide when it answers.
class _FakeMovieService extends MovieService {
  final calls = <String>[];
  final _pending = <String, Completer<List<Map<String, dynamic>>>>{};
  Object? failWith;

  Map<String, dynamic> _json(int id, String title) => {
        'id': id,
        'title': title,
        'year': 2020,
        'rating': 7.0,
        'runtime': 100,
        'genres': <String>[],
        'summary': '',
        'medium_cover_image': '',
      };

  /// Answers the pending request for [term] with one movie titled after it.
  void answer(String term) =>
      _pending[term]!.complete([_json(term.length, 'Result for $term')]);

  @override
  Future<List<Map<String, dynamic>>> listMovies({
    String? genre,
    String? queryTerm,
    int limit = 20,
    int page = 1,
    String sortBy = 'date_added',
    int minimumRating = 0,
  }) {
    calls.add(queryTerm ?? '');
    if (failWith != null) return Future.error(failWith!);
    return (_pending[queryTerm!] = Completer()).future;
  }
}

void main() {
  late _FakeMovieService service;
  late SearchViewModel vm;

  setUp(() {
    service = _FakeMovieService();
    vm = SearchViewModel(MovieRepository(service));
  });

  tearDown(() => vm.dispose());

  testWidgets('does not search until typing pauses', (tester) async {
    vm.onTermChanged('a');
    await tester.pump(const Duration(milliseconds: 200));
    vm.onTermChanged('ab');
    await tester.pump(const Duration(milliseconds: 200));
    vm.onTermChanged('abc');
    await tester.pump(const Duration(milliseconds: 200));

    expect(service.calls, isEmpty, reason: 'still inside the debounce window');

    await tester.pump(const Duration(milliseconds: 500));
    expect(service.calls, ['abc'], reason: 'one request, for the final term');
  });

  testWidgets('shows results once the request answers', (tester) async {
    vm.onTermChanged('marvel');
    await tester.pump(const Duration(milliseconds: 500));
    expect(vm.isLoading, isTrue);

    service.answer('marvel');
    await tester.pump();

    expect(vm.isLoading, isFalse);
    expect(vm.results.single.title, 'Result for marvel');
    expect(vm.error, isNull);
  });

  testWidgets('a slow earlier answer cannot overwrite a newer term',
      (tester) async {
    vm.onTermChanged('iron');
    await tester.pump(const Duration(milliseconds: 500)); // request 1 in flight

    vm.onTermChanged('iron man');
    await tester.pump(const Duration(milliseconds: 500)); // request 2 in flight

    service.answer('iron man'); // the newer one lands first...
    await tester.pump();
    service.answer('iron'); // ...then the stale one arrives late
    await tester.pump();

    expect(vm.results.single.title, 'Result for iron man');
    expect(vm.isLoading, isFalse);
  });

  testWidgets('clearing the box empties the results and stops loading',
      (tester) async {
    vm.onTermChanged('marvel');
    await tester.pump(const Duration(milliseconds: 500));
    service.answer('marvel');
    await tester.pump();
    expect(vm.results, isNotEmpty);

    vm.onTermChanged('');
    await tester.pump();

    expect(vm.results, isEmpty);
    expect(vm.isLoading, isFalse);
    expect(vm.isEmptyTerm, isTrue);
  });

  testWidgets('a whitespace-only term is treated as empty', (tester) async {
    vm.onTermChanged('   ');
    await tester.pump(const Duration(seconds: 1));

    expect(vm.isEmptyTerm, isTrue);
    expect(service.calls, isEmpty, reason: 'nothing worth searching for');
  });

  testWidgets('a failed request reports an error and can be retried',
      (tester) async {
    service.failWith = Exception('offline');
    vm.onTermChanged('marvel');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(vm.error, isNotNull);
    expect(vm.isLoading, isFalse);

    service.failWith = null;
    final retry = vm.search();
    await tester.pump();
    service.answer('marvel');
    await retry;

    expect(vm.error, isNull);
    expect(vm.results, isNotEmpty);
  });
}
