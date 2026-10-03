import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The one floating message bar every screen uses: red for failures, green
/// for confirmations. Replaces any message still showing rather than queueing.
void showAppMessage(
  BuildContext context,
  String message, {
  bool isError = true,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.red : AppColors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
}
