import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../widgets/auth_prompt.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_logo.dart';
import '../widgets/language_toggle.dart';
import '../widgets/or_divider.dart';
import '../utils/auth_action.dart';
import '../view_models/auth_view_model.dart';
import '../../movies/views/main_screen.dart';
import 'forget_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() {
    return submitAuthForm(
      context,
      formKey: _formKey,
      action: (vm) => vm.login(_email.text.trim(), _password.text),
      onSuccess: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const MainScreen()),
      ),
    );
  }

  void _loginWithGoogle() {
    // TODO: sign in through Firebase with the Google provider.
  }

  void _open(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // The asset carries its own padding, so it needs no top gap.
            Image.asset(AppAssets.appIcon, width: context.w(253)),
            AuthTextField(
              controller: _email,
              hint: 'Email',
              icon: AppAssets.icEmail,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            SizedBox(height: context.h(24)),
            AuthTextField(
              controller: _password,
              hint: 'Password',
              icon: AppAssets.icPassword,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: Validators.password,
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _open(const ForgetPasswordScreen()),
                child: Text(
                  'Forget Password ?',
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(24)),
            AppButton.filled(
              label: 'Login',
              loading: context.watch<AuthViewModel>().isLoading,
              onPressed: _login,
            ),
            SizedBox(height: context.h(24)),
            AuthPrompt(
              question: "Don't Have Account ?",
              action: 'Create One',
              onTap: () => _open(const RegisterScreen()),
            ),
            SizedBox(height: context.h(24)),
            const OrDivider(),
            SizedBox(height: context.h(24)),
            AppButton.filled(
              label: 'Login With Google',
              icon: const GoogleLogo(),
              onPressed: _loginWithGoogle,
            ),
            SizedBox(height: context.h(24)),
            const LanguageToggle(),
            SizedBox(height: context.h(24)),
          ],
        ),
      ),
    );
  }
}
