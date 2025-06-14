import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  final double totalPlanIncome;
  final double totalActualIncome;
  final double totalPlanExpense;
  final double totalActualExpense;
  final double plannedRemaining;
  final double actualRemaining;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Container(
      height: 200.h,
      width: 300.w,
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
              style: StyleType.bodMed,
            ),
          ),
          DataColumn(
            label: AppText(
              text: localize.planned,
              style: StyleType.bodMed,
              fontWeight: FontWeight.w700,
            ),
          ),
          DataColumn(
            label: AppText(
              text: localize.actual,
              style: StyleType.bodMed,
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
                  text: NumberFormatter.formatToMoneyDouble(
                    context,
                    totalPlanIncome,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyDouble(
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
                  text: NumberFormatter.formatToMoneyDouble(
                    context,
                    totalPlanExpense,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyDouble(
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
                  text: NumberFormatter.formatToMoneyDouble(
                    context,
                    plannedRemaining,
                  ),
                  style: StyleType.bodSm,
                ),
              ),
              DataCell(
                AppText(
                  text: NumberFormatter.formatToMoneyDouble(
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
