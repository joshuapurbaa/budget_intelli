import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.height,
    this.width,
    this.noSize,
  });

  const AppCard.noSize({
    required this.child,
    this.height,
    this.width,
    super.key,
  }) : noSize = true;

  final Widget child;
  final double? height;
  final double? width;
  final bool? noSize;

  @override
  Widget build(BuildContext context) {
    if (noSize != null) {
      return Card(
        color: context.color.onPrimary.withValues(alpha: 0.3),
        child: child,
      );
    } else {
      return Card(
        color: context.color.onPrimary.withValues(alpha: 0.3),
        child: SizedBox(
          height: height,
          width: width,
          child: child,
        ),
      );
    }
  }
}
