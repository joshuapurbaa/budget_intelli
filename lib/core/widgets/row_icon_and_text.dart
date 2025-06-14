import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class RowIconAndText extends StatelessWidget {
  const RowIconAndText({
    required this.icon,
    required this.text,
    super.key,
  });

  final Widget icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        Gap.horizontal(12),
        Expanded(
          child: AppText(
            text: text,
            style: StyleType.titSm,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
