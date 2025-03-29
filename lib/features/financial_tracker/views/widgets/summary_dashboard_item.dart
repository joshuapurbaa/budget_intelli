import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';

class SummaryDashboardItem extends StatelessWidget {
  const SummaryDashboardItem({
    required this.transaction,
    super.key,
  });

  final FinancialTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final member = transaction.memberName;
    final expense = transaction.type == 'expense';

    print('transaction to string ${transaction}');

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
                Gap.vertical(5),
                MemberNameLocalization(
                  name: member,
                  color: context.color.onSurface.withOpacity(0.7),
                ),
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
                  )}',
                  style: StyleType.headSm,
                  color: context.color.error,
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
