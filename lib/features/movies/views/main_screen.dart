import 'package:flutter/material.dart';

import '../../../core/widgets/app_state_view.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_screen.dart';

/// Holds the four tabs and the floating nav bar. Only Home is built so far;
/// the rest show the shared empty state.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _placeholders = {
    1: 'Search is coming soon',
    2: 'Browse is coming soon',
    3: 'Your profile is coming soon',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          for (final message in _placeholders.values)
            AppStateView(emptyMessage: message),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}
