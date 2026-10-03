import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/profile/view_models/library_view_model.dart';

import 'helpers/fakes.dart';

List<int> _ids(List movies) => [for (final m in movies) m.id as int];

void main() {
  late FakeLibraryRepository repository;
  late LibraryViewModel vm;

  setUp(() {
    repository = FakeLibraryRepository(
      watchList: [fakeMovie(1), fakeMovie(2)],
      history: [fakeMovie(7), fakeMovie(8), fakeMovie(9)],
    );
    vm = LibraryViewModel(repository);
  });

  group('load', () {
    test('fills both lists and reports saved movies', () async {
      await vm.load();

      expect(_ids(vm.watchList), [1, 2]);
      expect(_ids(vm.history), [7, 8, 9]);
      expect(vm.isSaved(2), isTrue);
      expect(vm.isSaved(99), isFalse);
      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
    });

    test('flags an error instead of throwing when the read fails', () async {
      repository.failingReads = true;
      await vm.load();

      expect(vm.hasError, isTrue);
      expect(vm.isLoading, isFalse);
    });
  });

  group('toggleWatchList', () {
    setUp(() => vm.load());

    test('saves a new movie to the top and persists it', () async {
      final saved = await vm.toggleWatchList(fakeMovie(5));

      expect(saved, isTrue);
      expect(_ids(vm.watchList), [5, 1, 2]);
      expect(_ids(repository.stored['watchlist']!), [5, 1, 2]);
    });

    test('removes a movie that was already saved', () async {
      final saved = await vm.toggleWatchList(fakeMovie(1));

      expect(saved, isFalse);
      expect(_ids(vm.watchList), [2]);
      expect(_ids(repository.stored['watchlist']!), [2]);
    });

    test('shows the change straight away, before the write finishes', () async {
      final pending = vm.toggleWatchList(fakeMovie(5));

      expect(vm.isSaved(5), isTrue, reason: 'optimistic update');
      await pending;
    });

    test('undoes the change and returns null when saving fails', () async {
      repository.failing = true;
      final saved = await vm.toggleWatchList(fakeMovie(5));

      expect(saved, isNull);
      expect(_ids(vm.watchList), [1, 2], reason: 'rolled back');
    });

    test('undoes a failed removal too', () async {
      repository.failing = true;
      final saved = await vm.toggleWatchList(fakeMovie(1));

      expect(saved, isNull);
      expect(vm.isSaved(1), isTrue);
    });
  });

  group('addToHistory', () {
    setUp(() => vm.load());

    test('puts a newly watched movie at the top', () async {
      await vm.addToHistory(fakeMovie(5));

      expect(_ids(vm.history), [5, 7, 8, 9]);
      expect(_ids(repository.stored['history']!), [5, 7, 8, 9]);
    });

    test('watching again moves it up instead of listing it twice', () async {
      await vm.addToHistory(fakeMovie(9));

      expect(_ids(vm.history), [9, 7, 8]);
      expect(_ids(repository.stored['history']!), [9, 7, 8]);
    });

    test('keeps the entry for this session when the write fails', () async {
      repository.failing = true;
      await vm.addToHistory(fakeMovie(5));

      expect(vm.history.first.id, 5, reason: 'best effort, never throws');
    });

    test('does not touch the watch list', () async {
      await vm.addToHistory(fakeMovie(5));

      expect(_ids(vm.watchList), [1, 2]);
    });
  });

  test('clear forgets both lists so the next account starts empty', () async {
    await vm.load();
    vm.clear();

    expect(vm.watchList, isEmpty);
    expect(vm.history, isEmpty);
    expect(vm.isSaved(1), isFalse);
  });

  test('notifies listeners when something changes', () async {
    var notifications = 0;
    vm.addListener(() => notifications++);

    await vm.load();
    final afterLoad = notifications;
    await vm.addToHistory(fakeMovie(5));

    expect(afterLoad, greaterThan(0));
    expect(notifications, greaterThan(afterLoad));
  });
}
