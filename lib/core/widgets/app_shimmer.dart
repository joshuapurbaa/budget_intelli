import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({
    required this.height,
    required this.width,
    super.key,
    this.borderRadius,
  });

  final double height;
  final double width;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      child: SizedBox(
        height: height.h,
        width: width.w,
        child: Shimmer.fromColors(
          baseColor: colorScheme.surface,
          highlightColor: colorScheme.onInverseSurface,
          child: ColoredBox(
            color: colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
