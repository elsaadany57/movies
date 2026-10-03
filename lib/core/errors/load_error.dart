import '../localization/l10n.dart';

/// Why a screen could not load. View models record the kind and leave the
/// wording to the screen, so the message follows the current language.
enum LoadError {
  movies,
  movie,
  search,
  profile,
  library;

  String message(AppLocalizations l10n) => switch (this) {
        movies => l10n.loadMoviesFailed,
        movie => l10n.loadMovieFailed,
        search => l10n.searchFailed,
        profile => l10n.loadProfileFailed,
        library => l10n.loadLibraryFailed,
      };
}
