import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class LabelWithDividerRight extends StatelessWidget {
  const LabelWithDividerRight({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          text: label,
          style: StyleType.bodSm,
        ),
        Gap.horizontal(8),
        Expanded(
          child: AppDivider(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
