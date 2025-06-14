import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.color,
    this.thickness,
    this.padding,
  });

  final Color? color;
  final double? thickness;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkModeSetting;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Divider(
        height: 1,
        color: color ??
            (isDarkMode
                ? context.color.onPrimary.withValues(
                    alpha: 0.1,
                  )
                : context.color.outlineVariant.withValues(alpha: 0.3)),
        thickness: thickness ?? 1,
      ),
    );
  }
}
