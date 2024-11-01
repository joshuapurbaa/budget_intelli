import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class TransactionItemList extends StatelessWidget {
  const TransactionItemList({
    required this.formatDate,
    required this.spendOn,
    required this.amount,
    required this.time,
    this.iconPath,
    this.categoryName,
    super.key,
    this.noChevron = false,
    this.onTap,
    this.hexColor,
  });

  final String formatDate;
  final String? spendOn;
  final int amount;
  final String time;
  final bool noChevron;
  final void Function()? onTap;
  final int? hexColor;
  final String? iconPath;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor:
                hexColor != null ? Color(hexColor!) : context.color.secondary,
            child: Padding(
              padding: getEdgeInsetsAll(8),
              child: AppText(
                text: formatDate,
                style: StyleType.labLg,
                maxLines: 2,
                color: context.color.onSecondary,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Gap.horizontal(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: spendOn ?? '-',
                  style: StyleType.bodMd,
                ),
                Row(
                  children: [
                    AppText(
                      text: '$categoryName, ',
                      style: StyleType.labLg,
                      color: context.color.onSurface.withOpacity(0.5),
                    ),
                    AppText(
                      text: time,
                      style: StyleType.labLg,
                      color: context.color.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppText(
            text: NumberFormatter.formatToMoneyInt(
              context,
              amount,
            ),
            style: StyleType.bodMd,
          ),
          if (!noChevron) ...[
            Gap.horizontal(10),
            Icon(
              Icons.chevron_right,
              color: context.color.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
