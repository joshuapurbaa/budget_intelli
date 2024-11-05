import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesIncomeToggle extends StatelessWidget {
  const ExpensesIncomeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocBuilder<FinancialDashboardCubit, FinancialDashboardState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context
                      .read<FinancialDashboardCubit>()
                      .toggleIncome(isIncome: false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: getEdgeInsetsSymmetric(
                    horizontal: 19,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: state.isIncome
                        ? context.color.onInverseSurface
                        : context.color.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    text: localize.expenses,
                    style: StyleType.bodMd,
                    color: state.isIncome
                        ? context.color.onSurface
                        : context.color.onPrimary,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context
                      .read<FinancialDashboardCubit>()
                      .toggleIncome(isIncome: true);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: getEdgeInsetsSymmetric(
                    horizontal: 19,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: state.isIncome
                        ? context.color.primary
                        : context.color.onInverseSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    text: localize.income,
                    style: StyleType.bodMd,
                    maxLines: 1,
                    color: state.isIncome
                        ? context.color.onPrimary
                        : context.color.onSurface,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
