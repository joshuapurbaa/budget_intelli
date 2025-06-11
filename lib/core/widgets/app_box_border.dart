import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppBoxBorder extends StatelessWidget {
  const AppBoxBorder({
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.color.outline.withValues(
              alpha: 0.5,
            ),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: padding ?? const EdgeInsets.all(16),
        margin: margin,
        child: child,
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
}
