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

  @override
  Widget build(BuildContext context) {
    if (noWidth != null) {
      return SizedBox(
        height: height ?? 58.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            side: side ?? BorderSide.none,
          ),
          onPressed: isActive == false ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.color(
                text: label,
                color: Theme.of(context).colorScheme.onPrimary,
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
          fixedSize: Size(width ?? 382.w, height ?? 58.h),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          side: side ?? BorderSide.none,
        ),
        onPressed: isActive == false ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.color(
              text: label,
              color: Theme.of(context).colorScheme.onInverseSurface,
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
        fixedSize: Size(width ?? 382.w, height ?? 58.h),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        side: side ?? BorderSide.none,
      ),
      onPressed: isActive == false ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyle.style(
              context,
              style: StyleType.bodLg,
            ).copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
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
