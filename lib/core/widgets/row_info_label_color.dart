import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class RowInfoLabelColor extends StatelessWidget {
  const RowInfoLabelColor({
    required this.color,
    required this.label,
    super.key,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppFixedContainer(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Gap.horizontal(8),
        AppText.color(
          text: label,
          color: Theme.of(context).colorScheme.onPrimary,
          style: StyleType.bodSm,
        ),
      ],
    );
  }
}
