import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profile/view_models/library_view_model.dart';
import '../../profile/views/profile_screen.dart';
import '../widgets/app_bottom_nav.dart';
import 'browse_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';

/// Holds the four tabs and the floating nav bar.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Fetched here, once the user is signed in, so the bookmark on a movie
    // already knows whether it is saved by the time anyone opens one.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<LibraryViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // IndexedStack so each tab keeps its scroll position and results.
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          SearchScreen(),
          BrowseScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}
