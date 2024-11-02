import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBoxSvg extends StatelessWidget {
  const AppBoxSvg({
    required this.icon,
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.shape,
    this.width,
    this.height,
    this.iconColor,
  });

  final String icon;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape? shape;
  final double? width;
  final double? height;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getEdgeInsetsAll(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.whiteBackground,
        borderRadius: shape == null ? borderRadius ?? getRadius(8) : null,
        shape: shape ?? BoxShape.rectangle,
      ),
      child: getSvgAsset(
        icon,
        width: (width ?? 30).w,
        height: (height ?? 30).h,
        color: iconColor,
      ),
    );
  }
}
