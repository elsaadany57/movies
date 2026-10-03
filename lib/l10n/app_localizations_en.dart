// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movies App';

  @override
  String get supervisedBy => 'Supervised by Mohamed Nabil';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get finish => 'Finish';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get tryAgain => 'Try again';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get exploreNow => 'Explore Now';

  @override
  String get introHeadline => 'Find Your Next\nFavorite Movie Here';

  @override
  String get introDescription =>
      'Get access to a huge library of movies\nto suit all tastes. You will surely like it.';

  @override
  String get onboardingDiscoverTitle => 'Discover Movies';

  @override
  String get onboardingDiscoverDescription =>
      'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.';

  @override
  String get onboardingGenresTitle => 'Explore All Genres';

  @override
  String get onboardingGenresDescription =>
      'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.';

  @override
  String get onboardingWatchlistTitle => 'Create Watchlists';

  @override
  String get onboardingWatchlistDescription =>
      'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.';

  @override
  String get onboardingReviewTitle => 'Rate, Review, and Learn';

  @override
  String get onboardingReviewDescription =>
      'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.';

  @override
  String get onboardingStartTitle => 'Start Watching Now';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get name => 'Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get login => 'Login';

  @override
  String get forgetPasswordLink => 'Forget Password ?';

  @override
  String get noAccount => 'Don\'t Have Account ?';

  @override
  String get createOne => 'Create One';

  @override
  String get or => 'OR';

  @override
  String get loginWithGoogle => 'Login With Google';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create Account';

  @override
  String get haveAccount => 'Already Have Account ?';

  @override
  String get forgetPasswordTitle => 'Forget Password';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get avatar => 'Avatar';

  @override
  String get accountCreated => 'Account created. Please log in.';

  @override
  String get resetLinkSent => 'Reset link sent. Check your inbox.';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterConfirmPassword => 'Enter your password confirmation';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsMismatch => 'Passwords do not match';

  @override
  String get invalidPhone => 'Enter a valid phone number';

  @override
  String get authInvalidEmail => 'That email address is not valid.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get authWrongCredentials => 'Wrong email or password.';

  @override
  String get authEmailInUse => 'That email already has an account.';

  @override
  String get authWeakPassword => 'Pick a stronger password.';

  @override
  String get authNoInternet => 'No internet connection.';

  @override
  String get authTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authNotAllowed =>
      'Email sign-in is switched off for this project.';

  @override
  String get availableNow => 'Available Now';

  @override
  String get watchNow => 'Watch Now';

  @override
  String get seeMore => 'See More';

  @override
  String get watch => 'Watch';

  @override
  String get screenShots => 'Screen Shots';

  @override
  String get similar => 'Similar';

  @override
  String get summary => 'Summary';

  @override
  String get cast => 'Cast';

  @override
  String get genres => 'Genres';

  @override
  String castName(String name) {
    return 'Name : $name';
  }

  @override
  String castCharacter(String character) {
    return 'Character : $character';
  }

  @override
  String get addedToHistory => 'Added to your History';

  @override
  String get addedToWatchList => 'Added to your Watch List';

  @override
  String get removedFromWatchList => 'Removed from your Watch List';

  @override
  String get watchListFailed => 'Could not update your Watch List';

  @override
  String get search => 'Search';

  @override
  String get searchPrompt => 'Search for a movie by name';

  @override
  String noMoviesMatch(String term) {
    return 'No movies match \"$term\"';
  }

  @override
  String noGenreMovies(String genre) {
    return 'No $genre movies found';
  }

  @override
  String get loadMoviesFailed => 'Could not load movies';

  @override
  String get loadMovieFailed => 'Could not load this movie';

  @override
  String get searchFailed => 'Could not search right now';

  @override
  String get loadProfileFailed => 'Could not load your profile';

  @override
  String get loadLibraryFailed => 'Could not load your movies';

  @override
  String get wishList => 'Wish List';

  @override
  String get watchList => 'Watch List';

  @override
  String get history => 'History';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get exit => 'Exit';

  @override
  String get notSignedIn => 'You are not signed in';

  @override
  String get pickAvatar => 'Pick Avatar';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get updateData => 'Update Data';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profileUpdateFailed => 'Could not update your profile';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'This removes your account and profile for good. It cannot be undone.';

  @override
  String get deleteAccountFailed =>
      'Could not delete your account. Sign in again.';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Adventure';

  @override
  String get genreAnimation => 'Animation';

  @override
  String get genreBiography => 'Biography';

  @override
  String get genreComedy => 'Comedy';

  @override
  String get genreCrime => 'Crime';

  @override
  String get genreDocumentary => 'Documentary';

  @override
  String get genreDrama => 'Drama';

  @override
  String get genreFamily => 'Family';

  @override
  String get genreFantasy => 'Fantasy';

  @override
  String get genreHistory => 'History';

  @override
  String get genreHorror => 'Horror';

  @override
  String get genreMusic => 'Music';

  @override
  String get genreMystery => 'Mystery';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreSciFi => 'Sci-Fi';

  @override
  String get genreSport => 'Sport';

  @override
  String get genreThriller => 'Thriller';

  @override
  String get genreWar => 'War';

  @override
  String get genreWestern => 'Western';
}
