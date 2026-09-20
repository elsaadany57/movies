import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../widgets/auth_prompt.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/language_toggle.dart';
import '../utils/auth_action.dart';
import '../view_models/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _phone = TextEditingController();

  int _avatar = AvatarPicker.defaultIndex;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _confirmPassword,
      _phone,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _createAccount() {
    return submitAuthForm(
      context,
      formKey: _formKey,
      action: (vm) => vm.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        phone: _phone.text.trim(),
        avatar: _avatar,
      ),
      successMessage: 'Account created. Please log in.',
      onSuccess: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: context.h(16));

    return AuthScaffold(
      title: 'Register',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AvatarPicker(onChanged: (index) => _avatar = index),
            gap,
            AuthTextField(
              controller: _name,
              hint: 'Name',
              icon: AppAssets.icName,
              validator: (value) => Validators.required(value, 'name'),
            ),
            gap,
            AuthTextField(
              controller: _email,
              hint: 'Email',
              icon: AppAssets.icEmail,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            gap,
            AuthTextField(
              controller: _password,
              hint: 'Password',
              icon: AppAssets.icPassword,
              obscure: true,
              validator: Validators.password,
            ),
            gap,
            AuthTextField(
              controller: _confirmPassword,
              hint: 'Confirm Password',
              icon: AppAssets.icPassword,
              obscure: true,
              validator: (value) =>
                  Validators.confirmPassword(value, _password.text),
            ),
            gap,
            AuthTextField(
              controller: _phone,
              hint: 'Phone Number',
              icon: AppAssets.icPhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: Validators.phone,
            ),
            SizedBox(height: context.h(24)),
            AppButton.filled(
              label: 'Create Account',
              loading: context.watch<AuthViewModel>().isLoading,
              onPressed: _createAccount,
            ),
            SizedBox(height: context.h(16)),
            AuthPrompt(
              question: 'Already Have Account ?',
              action: 'Login',
              onTap: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: context.h(16)),
            const LanguageToggle(),
            SizedBox(height: context.h(24)),
          ],
        ),
      ),
    );
  }
}
