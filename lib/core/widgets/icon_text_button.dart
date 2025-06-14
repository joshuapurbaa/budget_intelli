import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    required this.label,
    required this.onPressed,
    required this.iconPath,
    this.height,
    this.style,
    this.isActive,
    this.width,
    super.key,
    this.backgroundColor,
    this.side,
  });

  final String label;
  final StyleType? style;
  final VoidCallback onPressed;
  final bool? isActive;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderSide? side;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 382.w, height ?? 58.h),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        side: side ?? BorderSide.none,
      ),
      onPressed: isActive == false ? null : onPressed,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: getPngAsset(
              iconPath,
            ),
          ),
          Center(
            child: AppText(
              text: label,
              style: style ?? StyleType.bodLg,
            ),
          ),
        ],
      ),
    );
  }
}
