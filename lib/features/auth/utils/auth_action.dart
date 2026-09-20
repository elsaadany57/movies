import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../view_models/auth_view_model.dart';

/// Validates the form, runs [action], then either reports the view model's
/// error or hands control to [onSuccess]. Every auth screen submits this way.
Future<void> submitAuthForm(
  BuildContext context, {
  required GlobalKey<FormState> formKey,
  required Future<bool> Function(AuthViewModel vm) action,
  required VoidCallback onSuccess,
  String? successMessage,
}) async {
  if (!formKey.currentState!.validate()) return;

  final viewModel = context.read<AuthViewModel>();
  final succeeded = await action(viewModel);

  // The await means this context may be gone by now.
  if (!context.mounted) return;

  if (!succeeded) {
    showAuthMessage(context, viewModel.error ?? 'Something went wrong.');
    return;
  }

  if (successMessage != null) {
    showAuthMessage(context, successMessage, isError: false);
  }
  onSuccess();
}

void showAuthMessage(
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
