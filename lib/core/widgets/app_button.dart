import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.height,
    this.isActive,
    this.width,
    super.key,
    this.backgroundColor,
    this.side,
    this.labelColor,
    this.success,
    this.back,
    this.noWidth,
    this.outlined = false,
  });

  const AppButton.darkLabel({
    required this.label,
    required this.onPressed,
    this.height,
    this.isActive,
    this.width,
    super.key,
    this.backgroundColor,
    this.side,
    this.success,
    this.back,
    this.labelColor,
    this.noWidth,
    this.outlined = false,
  });

  const AppButton.success({
    required this.label,
    required this.onPressed,
    this.height,
    this.isActive,
    this.width,
    super.key,
    this.backgroundColor,
    this.side,
    this.labelColor,
    this.back,
    this.noWidth,
    this.outlined = false,
  }) : success = true;

  // AppButton.noWidth
  const AppButton.noWidth({
    required this.label,
    required this.onPressed,
    this.height,
    this.isActive,
    super.key,
    this.backgroundColor,
    this.side,
    this.labelColor,
    this.back,
    this.success,
    this.width,
    this.noWidth = true,
    this.outlined = false,
  });

  const AppButton.outlined({
    required this.label,
    required this.onPressed,
    this.height,
    this.isActive,
    this.width,
    super.key,
    this.backgroundColor,
    this.side,
    this.labelColor,
    this.back,
    this.success,
    this.noWidth,
    this.outlined = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool? isActive;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderSide? side;
  final Color? labelColor;
  final bool? success;
  final bool? back;
  final bool? noWidth;
  final bool? outlined;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.color;
    if (outlined == true) {
      return SizedBox(
        height: height ?? 50.h,
        width: width ?? 382.w,
        child: OutlinedButton(
          onPressed: isActive == false ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.color(
                text: label,
                color: labelColor ?? colorScheme.onSurface,
                style: StyleType.bodLg,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn() // uses `Animate.defaultDuration`
            .scale() // inherits duration from fadeIn
            .move(
              delay: 300.ms,
              duration: 600.ms,
            ),
      );
    }

    if (noWidth != null) {
      return SizedBox(
        height: height ?? 50.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            side: side ?? BorderSide.none,
          ),
          onPressed: isActive == false ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.color(
                text: label,
                color: labelColor ?? colorScheme.onPrimary,
                style: StyleType.bodLg,
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn() // uses `Animate.defaultDuration`
          .scale() // inherits duration from fadeIn
          .move(
            delay: 300.ms,
            duration: 600.ms,
          );
    }

    if (success != null) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width ?? 382.w, height ?? 50.h),
          backgroundColor: colorScheme.inverseSurface,
          side: side ?? BorderSide.none,
        ),
        onPressed: isActive == false ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.color(
              text: label,
              color: labelColor ?? colorScheme.onInverseSurface,
              style: StyleType.bodLg,
            ),
            Gap.horizontal(8),
            if (back == null)
              getLottieAsset(
                fastForward,
              ),
          ],
        ),
      )
          .animate()
          .fadeIn() // uses `Animate.defaultDuration`
          .scale() // inherits duration from fadeIn
          .move(
            delay: 300.ms,
            duration: 600.ms,
          );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 382.w, height ?? 50.h),
        backgroundColor: backgroundColor ?? colorScheme.primary,
        side: side ?? BorderSide.none,
      ),
      onPressed: isActive == false ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            text: label,
            style: StyleType.bodLg,
            color: labelColor ?? colorScheme.onPrimary,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn() // uses `Animate.defaultDuration`
        .scale() // inherits duration from fadeIn
        .move(
          delay: 300.ms,
          duration: 600.ms,
        );
  }
}
