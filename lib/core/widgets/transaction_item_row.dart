import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class TransactionItemRow extends StatelessWidget {
  const TransactionItemRow({
    required this.icon,
    required this.backgroundColor,
    required this.name,
    required this.description,
    required this.amountFormatted,
    required this.time,
    required this.whenTime,
    required this.isIncome,
    super.key,
  });
  final String icon;
  final Color backgroundColor;
  final String name;
  final String description;
  final String amountFormatted;
  final String time;
  final String whenTime;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        AppBoxSvg(
          icon: icon,
          backgroundColor: backgroundColor,
          shape: BoxShape.circle,
          iconColor: colorScheme.onTertiary,
          width: 25,
          height: 25,
        ),
        Gap.horizontal(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.reg16(
                text: name,
              ),
              Gap.vertical(4),
              AppText.italic(
                text: description,
                style: StyleType.labLg,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText.medium16(
              text: amountFormatted,
              color: isIncome ? colorScheme.primary : colorScheme.error,
            ),
            Gap.vertical(4),
            Row(
              children: [
                AppText.reg12(
                  text: time,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
                Gap.horizontal(8),
                AppText.reg12(
                  text: whenTime,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
