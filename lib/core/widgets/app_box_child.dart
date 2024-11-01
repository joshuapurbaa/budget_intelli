import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class AppBoxChild extends StatelessWidget {
  const AppBoxChild({
    required this.child,
    super.key,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.border,
    this.boxShadow,
  });

  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? getEdgeInsetsAll(16),
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: getRadius(16),
          color: Theme.of(context).colorScheme.surface,
          border: border,
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}
