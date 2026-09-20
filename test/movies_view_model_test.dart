import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';
import 'package:movies_app/data/services/movie_service.dart';
import 'package:movies_app/features/movies/view_models/movies_view_model.dart';

void main() {
  test('loadMovies fills the movie list', () async {
    final vm = MoviesViewModel(MovieRepository(MovieService()));

    await vm.loadMovies();

    expect(vm.isLoading, false);
    expect(vm.error, isNull);
    expect(vm.movies, isNotEmpty);
  });
}
