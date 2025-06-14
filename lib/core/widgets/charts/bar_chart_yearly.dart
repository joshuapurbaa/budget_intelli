import 'package:budget_intelli/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartYearly extends StatelessWidget {
  const BarChartYearly({
    required this.yearlyTransactions,
    super.key,
  });

  final Map<String, double> yearlyTransactions;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    if (yearlyTransactions.isNotEmpty) {
      var yearlyAmounts = <double>[];
      var yearTitles = <String>[];
      double? maxY;
      yearlyAmounts = yearlyTransactions.values.toList();
      maxY = yearlyAmounts
          .reduce((value, element) => value > element ? value : element);

      yearTitles = yearlyTransactions.keys.toList();

      return BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 8,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  NumberFormat.compact().format(rod.toY.toInt()),
                  const TextStyle(
                    color: AppColor.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                getTitlesWidget: (value, meta) {
                  String text;
                  if (yearTitles.isNotEmpty) {
                    text = yearTitles[value.toInt()];
                  } else {
                    text = '';
                  }
                  return SideTitleWidget(
                    meta: meta,
                    space: 4,
                    child: AppText(
                      text: text,
                      style: StyleType.bodSm,
                      color: AppColor.blue,
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List.generate(
            yearlyAmounts.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: yearlyAmounts[index],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          ),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY,
        ),
      );
    } else {
      return SizedBox(
        child: Center(
          child: AppText(
            text: localize.noDataAvailable,
            style: StyleType.headSm,
          ),
        ),
      );
    }
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppColor.blue,
          AppColor.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}
