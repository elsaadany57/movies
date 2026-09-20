import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/network_poster.dart';
import '../../../data/models/cast_member.dart';

/// One rounded row in the Cast list: portrait on the left, name and
/// character on the right.
class CastTile extends StatelessWidget {
  const CastTile({super.key, required this.member});

  final CastMember member;

  @override
  Widget build(BuildContext context) {
    final line = TextStyle(fontSize: context.sp(16), color: AppColors.white);

    return Container(
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.w(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: context.w(50),
            child: NetworkPoster(
              url: member.imageUrl,
              radius: context.w(8),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${member.name}', style: line),
                SizedBox(height: context.h(4)),
                Text('Character : ${member.character}', style: line),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
