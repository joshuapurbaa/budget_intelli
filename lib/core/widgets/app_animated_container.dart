import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppAnimatedContainer extends StatelessWidget {
  const AppAnimatedContainer({
    required this.child,
    super.key,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.duration,
    this.borderRadius,
  });

  final Widget child;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final Duration? duration;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration ?? const Duration(milliseconds: 300),
        height: height,
        alignment: Alignment.center,
        padding: padding ?? getEdgeInsetsAll(16),
        margin: margin,
        child: child,
      ).animate().fadeIn().scale().move(
            delay: 300.ms,
            duration: 600.ms,
          ),
    );
  }
}
