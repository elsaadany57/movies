import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/utils/app_snackbar.dart';
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
    final l10n = context.l10n;
    showAppMessage(
      context,
      viewModel.failure?.message(l10n) ?? l10n.somethingWentWrong,
    );
    return;
  }

  if (successMessage != null) {
    showAppMessage(context, successMessage, isError: false);
  }
  onSuccess();
}
