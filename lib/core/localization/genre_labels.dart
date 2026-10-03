import 'l10n.dart';

/// The display name for a genre in the current language.
///
/// The API only speaks English and its genre names double as the query value
/// for filtering, so the English name stays the identity everywhere in the
/// code and is translated only at the point it is drawn. A genre without a
/// translation (the API has a few rarer ones) falls back to its English name.
String genreLabel(AppLocalizations l10n, String apiName) {
  return switch (apiName) {
    'Action' => l10n.genreAction,
    'Adventure' => l10n.genreAdventure,
    'Animation' => l10n.genreAnimation,
    'Biography' => l10n.genreBiography,
    'Comedy' => l10n.genreComedy,
    'Crime' => l10n.genreCrime,
    'Documentary' => l10n.genreDocumentary,
    'Drama' => l10n.genreDrama,
    'Family' => l10n.genreFamily,
    'Fantasy' => l10n.genreFantasy,
    'History' => l10n.genreHistory,
    'Horror' => l10n.genreHorror,
    'Music' => l10n.genreMusic,
    'Mystery' => l10n.genreMystery,
    'Romance' => l10n.genreRomance,
    'Sci-Fi' => l10n.genreSciFi,
    'Sport' => l10n.genreSport,
    'Thriller' => l10n.genreThriller,
    'War' => l10n.genreWar,
    'Western' => l10n.genreWestern,
    _ => apiName,
  };
}
