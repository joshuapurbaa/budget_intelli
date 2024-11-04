import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryDashboardList extends StatelessWidget {
  const SummaryDashboardList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialDashboardCubit, FinancialDashboardState>(
      builder: (context, state) {
        final transactions = state.transactions;
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
      },
    );
  }
}
