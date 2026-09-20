import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Every remote image in the app goes through here so loading and failure
/// look the same everywhere: a flat surface block, never a broken icon.
class NetworkPoster extends StatelessWidget {
  const NetworkPoster({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.radius = 0,
  });

  final String url;
  final BoxFit fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Widget image = url.isEmpty
        ? const _Placeholder()
        : Image.network(
            url,
            fit: fit,
            errorBuilder: (_, _, _) => const _Placeholder(),
            frameBuilder: (_, child, frame, wasSyncLoaded) {
              if (wasSyncLoaded || frame != null) return child;
              return const _Placeholder();
            },
          );

    if (radius > 0) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: image,
      );
    }
    return image;
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface,
      child: SizedBox.expand(),
    );
  }
}
