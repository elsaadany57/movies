import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../utils/auth_action.dart';
import '../view_models/auth_view_model.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _verify() {
    return submitAuthForm(
      context,
      formKey: _formKey,
      action: (vm) => vm.sendPasswordReset(_email.text.trim()),
      successMessage: 'Reset link sent. Check your inbox.',
      onSuccess: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Forget Password',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset(AppAssets.forgetPassword),
            const SizedBox(height: 48),
            AuthTextField(
              controller: _email,
              hint: 'Email',
              icon: AppAssets.icEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
            ),
            const SizedBox(height: 24),
            AppButton.filled(
              label: 'Verify Email',
              loading: context.watch<AuthViewModel>().isLoading,
              onPressed: _verify,
            ),
          ],
        ),
      ),
    );
  }
}
