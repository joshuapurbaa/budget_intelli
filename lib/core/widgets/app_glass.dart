import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppGlass extends StatelessWidget {
  const AppGlass({
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
    this.isSelected = false,
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
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final themeMode = ControllerHelper.getThemeMode(context);
    final isDarkMode = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration ?? const Duration(milliseconds: 300),
        height: height,
        alignment: Alignment.center,
        padding: padding ?? getEdgeInsetsAll(16),
        margin: margin,
        decoration: BoxDecoration(
          color: isSelected
              ? isDarkMode
                  ? context.color.primary
                  : context.color.primaryContainer
              : (isDarkMode
                  ? context.color.secondaryContainer
                  : context.color.surface),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 16),
          ),
          boxShadow: [
            appBoxShadow(
              context,
            ),
          ],
        ),
        child: child,
      ).animate().fadeIn().scale().move(
            delay: 300.ms,
            duration: 600.ms,
          ),
    );
  }
}
