import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryDashboardFilter extends StatelessWidget {
  const SummaryDashboardFilter({
    required this.state,
    super.key,
  });

  final FinancialDashboardState state;

  @override
  Widget build(BuildContext context) {
    final filterBy = state.filterBy;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context
                  .read<FinancialDashboardCubit>()
                  .setSummaryFilterBy(SummaryFilterBy.day);
            },
            child: Container(
              padding: getEdgeInsetsAll(12),
              decoration: BoxDecoration(
                color: filterBy == SummaryFilterBy.day
                    ? context.color.primary
                    : context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  AppText(
                    text: 'Day',
                    style: StyleType.bodLg,
                    color: filterBy == SummaryFilterBy.day
                        ? context.color.primaryContainer
                        : null,
                  ),
                  Gap.vertical(5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AppText(
                        text: r'$',
                        style: StyleType.bodMd,
                        color: filterBy == SummaryFilterBy.day
                            ? context.color.primaryContainer
                            : null,
                      ),
                      AppText(
                        text: NumberFormatter.formatToMoneyDouble(
                          context,
                          state.dayTotalAmount,
                          isSymbol: false,
                        ),
                        style: StyleType.headSm,
                        color: filterBy == SummaryFilterBy.day
                            ? context.color.primaryContainer
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap.horizontal(5),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context
                  .read<FinancialDashboardCubit>()
                  .setSummaryFilterBy(SummaryFilterBy.week);
            },
            child: Container(
              padding: getEdgeInsetsAll(12),
              decoration: BoxDecoration(
                color: filterBy == SummaryFilterBy.week
                    ? context.color.primary
                    : context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  AppText(
                    text: 'Week',
                    style: StyleType.bodLg,
                    color: filterBy == SummaryFilterBy.week
                        ? context.color.primaryContainer
                        : null,
                  ),
                  Gap.vertical(5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AppText(
                        text: r'$',
                        style: StyleType.bodMd,
                        color: filterBy == SummaryFilterBy.week
                            ? context.color.primaryContainer
                            : null,
                      ),
                      AppText(
                        text: NumberFormatter.formatToMoneyDouble(
                          context,
                          state.weekTotalAmount,
                          isSymbol: false,
                        ),
                        style: StyleType.headSm,
                        color: filterBy == SummaryFilterBy.week
                            ? context.color.primaryContainer
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap.horizontal(5),
        Expanded(
          child: GestureDetector(
            onTap: () {
              context
                  .read<FinancialDashboardCubit>()
                  .setSummaryFilterBy(SummaryFilterBy.month);
            },
            child: Container(
              padding: getEdgeInsetsAll(12),
              decoration: BoxDecoration(
                color: filterBy == SummaryFilterBy.month
                    ? context.color.primary
                    : context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  AppText(
                    text: 'Month',
                    style: StyleType.bodLg,
                    color: filterBy == SummaryFilterBy.month
                        ? context.color.primaryContainer
                        : null,
                  ),
                  Gap.vertical(5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AppText(
                        text: r'$',
                        style: StyleType.bodMd,
                        color: filterBy == SummaryFilterBy.month
                            ? context.color.primaryContainer
                            : null,
                      ),
                      AppText(
                        text: NumberFormatter.formatToMoneyDouble(
                          context,
                          state.monthTotalAmount,
                          isSymbol: false,
                        ),
                        style: StyleType.headSm,
                        color: filterBy == SummaryFilterBy.month
                            ? context.color.primaryContainer
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
