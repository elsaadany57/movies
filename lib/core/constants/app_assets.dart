class AppAssets {
  static const _images = 'assets/images';
  static const _icons = 'assets/icons';

  static const appIcon = '$_images/splash/app_icon.png';
  static const routeLogo = '$_images/splash/route_logo.png';

  static const onboarding1 = '$_images/onboarding/onboarding_1.png';
  static const onboarding2 = '$_images/onboarding/onboarding_2.png';
  static const onboarding3 = '$_images/onboarding/onboarding_3.png';
  static const onboarding4 = '$_images/onboarding/onboarding_4.png';
  static const onboarding5 = '$_images/onboarding/onboarding_5.png';
  static const onboarding6 = '$_images/onboarding/onboarding_6.png';

  static const forgetPassword = '$_images/auth/forget_password.png';

  /// Every selectable avatar, in the order the pickers show them.
  static const avatars = [
    '$_images/avatars/avatar_1.png',
    '$_images/avatars/avatar_2.png',
    '$_images/avatars/avatar_3.png',
    '$_images/avatars/avatar_4.png',
    '$_images/avatars/avatar_5.png',
    '$_images/avatars/avatar_6.png',
    '$_images/avatars/avatar_7.png',
    '$_images/avatars/avatar_8.png',
    '$_images/avatars/avatar_9.png',
    '$_images/avatars/avatar_10.png',
    '$_images/avatars/avatar_11.png',
    '$_images/avatars/avatar_12.png',
  ];

  /// Falls back to the first avatar when a stored index is out of range.
  static String avatarAt(int index) =>
      avatars[index.clamp(0, avatars.length - 1)];

  static const icEmail = '$_icons/ic_email.png';
  static const icPassword = '$_icons/ic_password.png';
  static const icPhone = '$_icons/ic_phone.png';
  static const icName = '$_icons/ic_name.png';
  static const icEyeOff = '$_icons/ic_eye_off.png';

  static const icWatchlist = '$_icons/ic_watchlist.png';
  static const icHistory = '$_icons/ic_history.png';

  static const navHome = '$_icons/nav_home.png';
  static const navSearch = '$_icons/nav_search.png';
  static const navBrowse = '$_icons/nav_browse.png';
  static const navProfile = '$_icons/nav_profile.png';

  static const availableNow = '$_images/home/available_now.png';
  static const watchNow = '$_images/home/watch_now.png';
  static const emptyPopcorn = '$_images/common/empty_popcorn.png';

  static const flagUs = '$_icons/flag_us.png';
  static const flagEg = '$_icons/flag_eg.png';
}
