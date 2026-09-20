import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// Scrollable page body shared by the auth screens: the yellow back arrow and
/// centred title appear only when [title] is given, which Login omits.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final title = this.title;

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: AppColors.primary),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: context.sp(20),
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.w(16)),
          child: child,
        ),
      ),
    );
  }
}
