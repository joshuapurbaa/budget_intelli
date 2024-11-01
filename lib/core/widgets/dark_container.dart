import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class DarkContainer extends StatelessWidget {
  const DarkContainer({
    required this.child,
    super.key,
    this.darkColor,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final Color? darkColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: setBoxDecoration(
        cornerAll: true,
        color: darkColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: borderRadius,
        radius: 12,
      ),
      child: child,
    );
  }
}
