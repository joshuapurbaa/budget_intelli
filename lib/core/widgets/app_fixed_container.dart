import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFixedContainer extends StatelessWidget {
  const AppFixedContainer({
    required this.height,
    required this.width,
    super.key,
    this.decoration,
    this.padding,
    this.margin,
    this.child,
    this.onTap,
  });

  final double height;
  final double width;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        height: height.h,
        width: width.h,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
