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
import '../../../core/localization/l10n.dart';

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
      successMessage: context.l10n.accountCreated,
      onSuccess: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final validators = Validators(l10n);
    final gap = SizedBox(height: context.h(16));

    return AuthScaffold(
      title: l10n.register,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AvatarPicker(onChanged: (index) => _avatar = index),
            gap,
            AuthTextField(
              controller: _name,
              hint: l10n.name,
              icon: AppAssets.icName,
              validator: validators.name,
            ),
            gap,
            AuthTextField(
              controller: _email,
              hint: l10n.email,
              icon: AppAssets.icEmail,
              keyboardType: TextInputType.emailAddress,
              validator: validators.email,
            ),
            gap,
            AuthTextField(
              controller: _password,
              hint: l10n.password,
              icon: AppAssets.icPassword,
              obscure: true,
              validator: validators.password,
            ),
            gap,
            AuthTextField(
              controller: _confirmPassword,
              hint: l10n.confirmPassword,
              icon: AppAssets.icPassword,
              obscure: true,
              validator: (value) =>
                  validators.confirmPassword(value, _password.text),
            ),
            gap,
            AuthTextField(
              controller: _phone,
              hint: l10n.phoneNumber,
              icon: AppAssets.icPhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: validators.phone,
            ),
            SizedBox(height: context.h(24)),
            AppButton.filled(
              label: l10n.createAccount,
              loading: context.watch<AuthViewModel>().isLoading,
              onPressed: _createAccount,
            ),
            SizedBox(height: context.h(16)),
            AuthPrompt(
              question: l10n.haveAccount,
              action: l10n.login,
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
