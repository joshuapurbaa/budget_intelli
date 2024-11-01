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
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Divider(
        height: 1,
        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
        thickness: thickness ?? 1,
      ),
    );
  }
}
