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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(
        top: 12,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header Row
          _buildTableRow(
            context,
            label: '',
            planned: localize.planned,
            actual: localize.actual,
            isHeader: true,
          ),
          Gap.vertical(8),
          AppDivider(
            color: context.color.onSurface.withValues(alpha: 0.3),
          ),
          Gap.vertical(8),
          // Income Row
          _buildTableRow(
            context,
            label: localize.income,
            planned: NumberFormatter.formatToMoneyDouble(
              context,
              totalPlanIncome,
            ),
            actual: NumberFormatter.formatToMoneyDouble(
              context,
              totalActualIncome,
            ),
          ),
          Gap.vertical(8),
          // Spending Row
          _buildTableRow(
            context,
            label: localize.spending,
            planned: NumberFormatter.formatToMoneyDouble(
              context,
              totalPlanExpense,
            ),
            actual: NumberFormatter.formatToMoneyDouble(
              context,
              totalActualExpense,
            ),
          ),
          Gap.vertical(8),
          // Remaining Row
          _buildTableRow(
            context,
            label: localize.remaining,
            planned: NumberFormatter.formatToMoneyDouble(
              context,
              plannedRemaining,
            ),
            actual: NumberFormatter.formatToMoneyDouble(
              context,
              actualRemaining,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context, {
    required String label,
    required String planned,
    required String actual,
    bool isHeader = false,
  }) {
    final textStyle = isHeader ? StyleType.bodMed : StyleType.bodSm;
    final fontWeight = isHeader ? FontWeight.w700 : FontWeight.normal;

    return Row(
      children: [
        // Label column
        Expanded(
          flex: 2,
          child: AppText(
            text: label,
            style: textStyle,
            fontWeight: isHeader ? fontWeight : FontWeight.w700,
          ),
        ),
        // Planned column
        Expanded(
          flex: 2,
          child: AppText(
            text: planned,
            style: textStyle,
            fontWeight: fontWeight,
            textAlign: TextAlign.center,
          ),
        ),
        // Actual column
        Expanded(
          flex: 2,
          child: AppText(
            text: actual,
            style: textStyle,
            fontWeight: fontWeight,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
