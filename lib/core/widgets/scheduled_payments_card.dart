import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class ScheduledPaymentsCard extends StatelessWidget {
  const ScheduledPaymentsCard({
    // required this.icon,
    // required this.backgroundColor,
    required this.name,
    required this.dueDateString,
    required this.amountFormatted,
    required this.date,
    required this.isCompleted,
    super.key,
  });

  // final String icon;
  // final Color backgroundColor;
  final String name;
  final String dueDateString;
  final String amountFormatted;
  final String date;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBoxChild(
      boxShadow: appBoxShadows(context),
      border: appBorder(context),
      margin: getEdgeInsets(bottom: 10),
      child: Row(
        children: [
          // AppBoxSvg(
          //   icon: icon,
          //   backgroundColor: backgroundColor,
          //   shape: BoxShape.circle,
          //   iconColor: colorScheme.onTertiary,
          //   width: 25,
          //   height: 25,
          // ),
          Gap.horizontal(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium16(
                  text: name,
                ),
                if (!isCompleted) ...[
                  Gap.vertical(4),
                  AppText.italic(
                    text: dueDateString,
                    style: StyleType.bodSm,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ],
            ),
          ),
          if (!isCompleted)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.medium16(
                  text: amountFormatted,
                  color: colorScheme.primary,
                ),
                Gap.vertical(4),
                AppText.reg12(
                  text: date,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          if (isCompleted)
            getPngAsset(
              completed,
              width: 50,
              height: 50,
            ),
        ],
      ),
    );
  }
}
