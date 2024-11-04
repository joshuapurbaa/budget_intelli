import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';

class SummaryDashboardList extends StatelessWidget {
  const SummaryDashboardList({
    required this.transactions, super.key,
  });

  final List<FinancialTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return SummaryDashboardItem(
            transaction: transactions[index],
          );
        },
      ),
    );
  }
}
