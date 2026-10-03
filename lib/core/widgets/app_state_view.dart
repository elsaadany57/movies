import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../errors/load_error.dart';
import '../localization/l10n.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// The shared loading / error / empty body, so no screen invents its own.
class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    this.isLoading = false,
    this.error,
    this.emptyMessage,
    this.onRetry,
  });

  final bool isLoading;

  /// Why loading failed; shown in the current language with a retry button.
  final LoadError? error;

  /// What to say when there is simply nothing to show (already translated).
  final String? emptyMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final l10n = context.l10n;
    final message = error?.message(l10n) ?? emptyMessage ?? l10n.nothingHereYet;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.emptyPopcorn, width: context.w(124)),
            SizedBox(height: context.h(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.sp(16), color: AppColors.white),
            ),
            if (error != null && onRetry != null) ...[
              SizedBox(height: context.h(16)),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  l10n.tryAgain,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
