import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../auth/utils/auth_action.dart';
import '../../auth/views/forget_password_screen.dart';
import '../../auth/views/login_screen.dart';
import '../../auth/widgets/auth_scaffold.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../view_models/profile_view_model.dart';
import '../widgets/avatar_grid_sheet.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileViewModel _vm = context.read<ProfileViewModel>();

  late final _name = TextEditingController(text: _vm.user?.name ?? '');
  late final _phone = TextEditingController(text: _vm.user?.phone ?? '');

  late int _avatar = _vm.user?.avatar ?? 0;
  bool _pickingAvatar = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final ok = await _vm.updateProfile(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      avatar: _avatar,
    );
    if (!mounted) return;

    setState(() => _saving = false);
    showAuthMessage(
      context,
      ok ? 'Profile updated' : 'Could not update your profile',
      isError: !ok,
    );
    if (ok) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete account?'),
        content: const Text(
          'This removes your account and profile for good. It cannot be '
          'undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final ok = await _vm.deleteAccount();
    if (!mounted) return;

    if (!ok) {
      showAuthMessage(context, 'Could not delete your account. Sign in again.');
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Pick Avatar',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: context.h(24)),
            GestureDetector(
              onTap: () => setState(() => _pickingAvatar = !_pickingAvatar),
              child: Image.asset(
                AppAssets.avatarAt(_avatar),
                width: context.w(150),
              ),
            ),
            SizedBox(height: context.h(32)),
            AuthTextField(
              controller: _name,
              hint: 'Name',
              icon: AppAssets.icName,
              validator: (value) => Validators.required(value, 'name'),
            ),
            SizedBox(height: context.h(16)),
            AuthTextField(
              controller: _phone,
              hint: 'Phone Number',
              icon: AppAssets.icPhone,
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            SizedBox(height: context.h(16)),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ForgetPasswordScreen(),
                  ),
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: context.sp(20),
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            if (_pickingAvatar) ...[
              SizedBox(height: context.h(24)),
              AvatarGridSheet(
                selected: _avatar,
                onSelected: (i) => setState(() => _avatar = i),
              ),
            ],
            SizedBox(height: context.h(32)),
            AppButton.filled(
              label: 'Delete Account',
              color: AppColors.red,
              onPressed: _confirmDelete,
            ),
            SizedBox(height: context.h(16)),
            AppButton.filled(
              label: 'Update Data',
              loading: _saving,
              onPressed: _save,
            ),
            SizedBox(height: context.h(24)),
          ],
        ),
      ),
    );
  }
}
