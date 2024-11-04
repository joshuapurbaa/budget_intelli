import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SummaryDashboardItem extends StatelessWidget {
  const SummaryDashboardItem({
    super.key,
    required this.transaction,
  });

  final FinancialTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final location = transaction.transactionLocation;
    final locationName = location?.subLocality ?? '';
    final expense = transaction.type == 'expense';
    return Padding(
      padding: getEdgeInsets(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: context.color.onInverseSurface,
            child: getPngAsset(
              cloth,
            ),
          ),
          Gap.horizontal(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: transaction.categoryName,
                  style: StyleType.headSm,
                ),
                if (locationName.isNotEmpty) ...[
                  Gap.vertical(5),
                  AppText(
                    text: locationName,
                    style: StyleType.bodMd,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (expense) ...[
                AppText(
                  text: '-${NumberFormatter.formatToMoneyDouble(
                    context,
                    transaction.amount,
                    decimalDigits: transaction.amount % 1 == 0 ? 0 : 2,
                  )}',
                  style: StyleType.headSm,
                ),
              ] else ...[
                AppText(
                  text: '+${transaction.amount}',
                  style: StyleType.headSm,
                ),
              ],
              AppText(
                text: transaction.accountName,
                style: StyleType.bodMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
