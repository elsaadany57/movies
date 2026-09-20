import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

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
  final String? error;
  final String? emptyMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final message = error ?? emptyMessage;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.emptyPopcorn, width: 124),
            const SizedBox(height: 16),
            Text(
              message ?? 'Nothing here yet',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.white),
            ),
            if (error != null && onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Try again',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
