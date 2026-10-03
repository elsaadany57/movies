import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/data/models/movie.dart';

void main() {
  group('Movie.toJson', () {
    test('reads back unchanged, which is how the library stores movies', () {
      const movie = Movie(
        id: 42,
        title: 'Doctor Strange',
        year: 2022,
        rating: 6.9,
        runtime: 126,
        genres: ['Action', 'Fantasy'],
        summary: 'not stored',
        coverUrl: 'https://img/cover.jpg',
        backgroundUrl: 'https://img/bg.jpg',
      );

      final copy = Movie.fromJson(movie.toJson());

      expect(copy.id, 42);
      expect(copy.title, 'Doctor Strange');
      expect(copy.year, 2022);
      expect(copy.rating, 6.9);
      expect(copy.runtime, 126);
      expect(copy.genres, ['Action', 'Fantasy']);
      expect(copy.coverUrl, 'https://img/cover.jpg');
      expect(copy.backgroundUrl, 'https://img/bg.jpg');
    });

    test('leaves the long summary out so stored entries stay small', () {
      final json = fakeMovieJson();

      expect(json.containsKey('summary'), isFalse);
      expect(json.containsKey('description_full'), isFalse);
    });
  });

  group('Movie.fromJson', () {
    test('survives a sparse API response', () {
      final movie = Movie.fromJson({'id': 1, 'title': 'Bare'});

      expect(movie.year, 0);
      expect(movie.rating, 0);
      expect(movie.genres, isEmpty);
      expect(movie.coverUrl, '');
      expect(movie.screenshots, isEmpty);
      expect(movie.cast, isEmpty);
      expect(movie.hasTrailer, isFalse);
    });

    test('reads the cast and screenshots the details endpoint adds', () {
      final movie = Movie.fromJson({
        'id': 1,
        'title': 'Full',
        'yt_trailer_code': 'abc123',
        'medium_screenshot_image1': 'a.jpg',
        'medium_screenshot_image2': '',
        'medium_screenshot_image3': 'c.jpg',
        'cast': [
          {'name': 'Ann', 'character_name': 'Hero', 'url_small_image': 'x.jpg'},
        ],
      });

      expect(movie.hasTrailer, isTrue);
      expect(movie.screenshots, ['a.jpg', 'c.jpg'], reason: 'blank one dropped');
      expect(movie.cast.single.name, 'Ann');
      expect(movie.cast.single.character, 'Hero');
    });

    test('takes the summary from whichever key the endpoint uses', () {
      expect(Movie.fromJson({'id': 1, 'summary': 'list'}).summary, 'list');
      expect(
        Movie.fromJson({'id': 1, 'description_full': 'details'}).summary,
        'details',
      );
    });
  });
}

Map<String, dynamic> fakeMovieJson() => const Movie(
      id: 1,
      title: 'X',
      year: 2000,
      rating: 5,
      runtime: 90,
      genres: [],
      summary: 'long text',
      coverUrl: '',
      backgroundUrl: '',
    ).toJson();
