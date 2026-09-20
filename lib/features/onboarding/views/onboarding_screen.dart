import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_assets.dart';
import '../../auth/views/login_screen.dart';
import '../models/onboarding_item.dart';
import '../widgets/onboarding_intro_page.dart';
import '../widgets/onboarding_sheet_page.dart';

/// Swipeable onboarding flow: one intro page followed by [onboardingItems].
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageDuration = Duration(milliseconds: 350);
  static const _pageCurve = Curves.easeInOut;
  static final _pageCount = onboardingItems.length + 1;

  final _controller = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Decode every poster up front so swiping never shows an empty frame.
    for (final image in [
      AppAssets.onboarding1,
      for (final item in onboardingItems) item.image,
    ]) {
      precacheImage(AssetImage(image), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(page, duration: _pageDuration, curve: _pageCurve);
  }

  void _next() {
    final page = _controller.page?.round() ?? 0;
    if (page >= _pageCount - 1) {
      _finish();
    } else {
      _goTo(page + 1);
    }
  }

  void _back() {
    final page = _controller.page?.round() ?? 0;
    if (page > 0) _goTo(page - 1);
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: PageView.builder(
          controller: _controller,
          itemCount: _pageCount,
          itemBuilder: (context, index) {
            if (index == 0) return OnboardingIntroPage(onExplore: _next);

            return OnboardingSheetPage(
              item: onboardingItems[index - 1],
              isLast: index == _pageCount - 1,
              onNext: _next,
              onBack: _back,
            );
          },
        ),
      ),
    );
  }
}
