import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../onboarding/views/onboarding_screen.dart';

/// Shows the logo briefly, then moves on to onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _duration = Duration(seconds: 2);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_duration, _openOnboarding);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: Center(child: Image.asset(AppAssets.appIcon, width: context.w(253)))),
              Image.asset(AppAssets.routeLogo, width: context.w(180)),
              SizedBox(height: context.h(4)),
              Text(
                'Supervised by Mohamed Nabil',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: context.sp(16),
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
