import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_state_view.dart';
import '../view_models/home_view_model.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/genre_row_section.dart';

/// The Home tab: featured carousel on top, one horizontal row per genre.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Deferred: load() notifies listeners, which cannot happen while this
    // widget's own build is still in flight.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading || vm.error != null) {
      return AppStateView(
        isLoading: vm.isLoading,
        error: vm.error,
        onRetry: () => context.read<HomeViewModel>().load(),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        FeaturedCarousel(movies: vm.featured),
        for (final row in vm.rows) ...[
          GenreRowSection(row: row),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
