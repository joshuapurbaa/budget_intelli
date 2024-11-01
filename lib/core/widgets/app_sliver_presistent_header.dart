import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSliverPersistentHeader extends SliverPersistentHeaderDelegate {
  const AppSliverPersistentHeader({
    required this.title,
    this.iconPath,
    this.color,
    this.onImageIconTap,
    this.onPaintBrushTap,
    this.onBackTap,
  });

  final String title;
  final String? iconPath;
  final int? color;
  final VoidCallback? onPaintBrushTap;
  final VoidCallback? onImageIconTap;
  final VoidCallback? onBackTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorUse = color == null ? context.color.primary : Color(color!);
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: colorUse,
          ),
          SafeArea(
            child: Row(
              children: [
                Gap.horizontal(12),
                GestureDetector(
                  onTap: onBackTap,
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    color: context.color.onSurface,
                    size: 30,
                  ),
                ),
                Gap.horizontal(8),
                GestureDetector(
                  onTap: onImageIconTap,
                  child: iconPath != null
                      ? Image.asset(
                          iconPath!,
                          width: 30,
                        )
                      : CircleAvatar(
                          backgroundColor: context.color.inverseSurface,
                          radius: 20,
                          child: Icon(
                            CupertinoIcons.photo,
                            color: context.color.primary,
                            size: 20,
                          ),
                        ),
                ),
                Gap.horizontal(8),
                Expanded(
                  child: AppText(
                    text: title,
                    style: StyleType.headMed,
                    maxLines: 1,
                  ),
                ),
                Gap.horizontal(8),
                GestureDetector(
                  onTap: onPaintBrushTap,
                  child: Icon(
                    CupertinoIcons.paintbrush,
                    color: context.color.onSurface,
                    size: 30,
                  ),
                ),
                Gap.horizontal(16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 130;

  @override
  double get minExtent => 130;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
