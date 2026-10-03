import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/localization/l10n.dart';

/// Carousel of the selectable avatars: the chosen one sits centred and large,
/// its neighbours peek in smaller on either side.
class AvatarPicker extends StatefulWidget {
  const AvatarPicker({super.key, this.onChanged});

  final ValueChanged<int>? onChanged;

  /// The avatar shown centred before the user swipes. Callers seed their own
  /// state with this, since [onChanged] only fires once the page changes.
  static int get defaultIndex => AppAssets.avatars.length ~/ 2;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  static const _avatars = AppAssets.avatars;
  static const _viewport = 0.42;
  static const _height = 160.0;

  // The source avatars differ in pixel size, so both states are given an
  // explicit box and the image is fitted into it.
  static const _selectedSize = 150.0;
  static const _unselectedSize = 90.0;

  late final _controller = PageController(
    viewportFraction: _viewport,
    initialPage: _selected,
  );

  int _selected = AvatarPicker.defaultIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _selected = index);
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.h(_height),
          child: PageView.builder(
            controller: _controller,
            itemCount: _avatars.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final selected = index == _selected;

              final size = context.w(
                selected ? _selectedSize : _unselectedSize,
              );

              return Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: size,
                  height: size,
                  child: Image.asset(_avatars[index], fit: BoxFit.contain),
                ),
              );
            },
          ),
        ),
        SizedBox(height: context.h(8)),
        Text(
          context.l10n.avatar,
          style: TextStyle(fontSize: context.sp(16), color: AppColors.white),
        ),
      ],
    );
  }
}
