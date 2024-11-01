import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class BudgetOverviewTable extends StatelessWidget {
  const BudgetOverviewTable({
    required this.totalPlanIncome,
    required this.totalActualIncome,
    required this.totalPlanExpense,
    required this.totalActualExpense,
    required this.plannedRemaining,
    required this.actualRemaining,
    super.key,
  });

  final int totalPlanIncome;
  final int totalActualIncome;
  final int totalPlanExpense;
  final int totalActualExpense;
  final int plannedRemaining;
  final int actualRemaining;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      child: DataTable(
        horizontalMargin: 0,
        columnSpacing: 25,
        dividerThickness: 0.2,
        headingRowHeight: 40,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 40,
        columns: [
          const DataColumn(
            label: AppText(
              text: '',
              style: StyleType.bodMd,
            ),
          ),
          DataColumn(
            label: AppText(
              text: localize.planned,
              style: StyleType.bodMd,
              fontWeight: FontWeight.w700,
            ),
          ),
          DataColumn(
            label: AppText(
              text: localize.actual,
              style: StyleType.bodMd,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                AppText(
                  text: localize.income,
                  style: StyleType.bodSm,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    totalPlanIncome,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    totalActualIncome,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                AppText(
                  text: localize.spending,
                  style: StyleType.bodSm,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    totalPlanExpense,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    totalActualExpense,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
            ],
          ),
          //   data row remaining
          DataRow(
            cells: [
              DataCell(
                AppText(
                  text: localize.remaining,
                  style: StyleType.bodSm,
                  fontWeight: FontWeight.w700,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    plannedRemaining,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    actualRemaining,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
