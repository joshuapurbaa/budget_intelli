import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineButtonPrimary extends StatelessWidget {
  const OutlineButtonPrimary({
    required this.label,
    required this.onPressed,
    this.height,
    this.style,
    this.isActive,
    this.width,
    super.key,
    this.backgroundColor,
    this.side,
    this.noWidth,
  });

  // OutlineButtonPrimary.noWidth
  const OutlineButtonPrimary.noWidth({
    required this.label,
    required this.onPressed,
    this.height,
    this.isActive,
    super.key,
    this.style,
    this.backgroundColor,
    this.side,
    this.width,
  }) : noWidth = true;

  final String label;
  final TextStyle? style;
  final VoidCallback onPressed;
  final bool? isActive;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderSide? side;
  final bool? noWidth;

  @override
  Widget build(BuildContext context) {
    if (noWidth != null) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        ),
        onPressed: isActive == false ? null : onPressed,
        child: Text(
          label,
          style: style ??
              AppTextStyle.style(
                context,
                style: StyleType.bodLg,
              ),
        ),
      )
          .animate()
          .fadeIn() // uses `Animate.defaultDuration`
          .scale() // inherits duration from fadeIn
          .move(delay: 300.ms, duration: 600.ms);
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: Size(width ?? 382.w, height ?? 58.h),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      ),
      onPressed: isActive == false ? null : onPressed,
      child: Text(
        label,
        style: style ??
            AppTextStyle.style(
              context,
              style: StyleType.bodLg,
            ),
      ),
    )
        .animate()
        .fadeIn() // uses `Animate.defaultDuration`
        .scale() // inherits duration from fadeIn
        .move(delay: 300.ms, duration: 600.ms);
  }
}
