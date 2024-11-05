import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FinancialTrackerDashboardBody extends StatelessWidget {
  const FinancialTrackerDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialDashboardCubit, FinancialDashboardState>(
      builder: (context, state) {
        var transactions = <FinancialTransaction>[];

        switch (state.filterBy) {
          case SummaryFilterBy.day:
            transactions = state.dayTransactions;
          case SummaryFilterBy.week:
            transactions = state.weekTransactions;
          case SummaryFilterBy.month:
            transactions = state.monthTransactions;
        }
        return SliverFillRemaining(
          child: Padding(
            padding: getEdgeInsetsAll(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: getEdgeInsetsAll(4),
                        decoration: BoxDecoration(
                          color: context.color.onInverseSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const ExpensesIncomeToggle(),
                      ),
                    ),
                    Gap.horizontal(10),
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          builder: (context) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.30,
                              ),
                              padding: getEdgeInsetsAll(20),
                              child: ListView.builder(
                                itemCount: AppStrings.monthListFullEn.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: AppText(
                                      text: AppStrings.monthListFullEn[index],
                                      style: StyleType.bodMd,
                                      color: context.color.onSurface,
                                    ),
                                    onTap: () {
                                      context.pop(
                                        AppStrings.monthListFullEn[index],
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );

                        if (result != null) {
                          final monthNumber = getBulanDariNama(
                            result,
                            context,
                          );

                          context.read<FinancialDashboardCubit>().selectMonth(
                                month: result,
                                monthNumStr: monthNumber ?? '',
                              );

                          context
                              .read<FinancialDashboardCubit>()
                              .getAllFinancialTransactionByMonthAndYear(
                                context,
                                monthStr: monthNumber,
                              );
                        }
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 130,
                          minWidth: 130,
                        ),
                        padding: getEdgeInsetsSymmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: context.color.onInverseSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText(
                                text: state.selectedMonth,
                                style: StyleType.bodMd,
                                color: context.color.onSurface,
                                maxLines: 1,
                              ),
                            ),
                            Gap.horizontal(5),
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: context.color.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Gap.vertical(20),
                const DashboardGraphic(),
                Gap.vertical(20),
                AnimatedSummaryDashboardFilter(
                  state: state,
                ),
                Gap.vertical(20),
                SummaryDashboardList(
                  transactions: transactions,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
