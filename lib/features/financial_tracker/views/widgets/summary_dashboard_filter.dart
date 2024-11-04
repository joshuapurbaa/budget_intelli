import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryDashboardFilter extends StatelessWidget {
  const SummaryDashboardFilter({
    required this.state, super.key,
  });

  final FinancialDashboardState state;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final widthSummaryContainer = width / 3;

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
              padding: getEdgeInsetsAll(14),
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const AppText(
                    text: 'Day',
                    style: StyleType.headSm,
                  ),
                  Gap.vertical(5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const AppText(
                        text: r'$',
                        style: StyleType.bodMd,
                      ),
                      AppText(
                        text: NumberFormatter.formatToMoneyDouble(
                          context,
                          state.dayTotalAmount,
                          isSymbol: false,
                        ),
                        style: StyleType.headMed,
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
              padding: getEdgeInsetsAll(14),
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const AppText(
                    text: 'Week',
                    style: StyleType.headSm,
                  ),
                  Gap.vertical(5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const AppText(
                        text: r'$',
                        style: StyleType.bodMd,
                      ),
                      AppText(
                        text: NumberFormatter.formatToMoneyDouble(
                          context,
                          state.weekTotalAmount,
                          isSymbol: false,
                        ),
                        style: StyleType.headMed,
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
              padding: getEdgeInsetsAll(14),
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const AppText(
                    text: 'Month',
                    style: StyleType.headSm,
                  ),
                  Gap.vertical(5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const AppText(
                        text: r'$',
                        style: StyleType.bodMd,
                      ),
                      AppText(
                        text: NumberFormatter.formatToMoneyDouble(
                          context,
                          state.monthTotalAmount,
                          isSymbol: false,
                        ),
                        style: StyleType.headMed,
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
