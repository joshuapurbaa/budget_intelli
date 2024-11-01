import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppGlass extends StatelessWidget {
  const AppGlass({
    required this.child,
    super.key,
    // required this.startGradient,
    // required this.endGradient,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.duration,
  });

  final Widget child;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final Duration? duration;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.color.secondaryContainer,
              context.color.surface,
              context.color.surface,
            ],
            stops: const [0, 1, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          // border: Border.all(
          //   width: 0.2,
          //   color: context.color.primary,
          // ),
          boxShadow: [
            appBoxShadow(
              context,
            ),
          ],
        ),
        child: child,
      )
          .animate()
          .fadeIn() // uses `Animate.defaultDuration`
          .scale() // inherits duration from fadeIn
          .move(
            delay: 300.ms,
            duration: 600.ms,
          ), // runs after the above w/new duration
    );
  }
}
