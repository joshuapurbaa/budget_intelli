import 'package:budget_intelli/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraphMonthly extends StatefulWidget {
  const LineGraphMonthly({super.key});

  @override
  State<LineGraphMonthly> createState() => _LineGraphMonthlyState();
}

class _LineGraphMonthlyState extends State<LineGraphMonthly> {
  double minX() {
    return 1;
  }

  double maxX() {
    final now = DateTime.now();
    return now.month.toDouble();
  }

  double minY() {
    return 0;
  }

  double maxY() {
    return 5;
  }

  List<LineChartBarData> _lineChartBarData() {
    return [
      LineChartBarData(
        spots: const [
          FlSpot(1, 0.2),
          FlSpot(2, 0.8),
          FlSpot(3, 1.2),
          FlSpot(4, 1.5),
          FlSpot(5, 1.8),
        ],
        isCurved: true,
        gradient: const LinearGradient(
          colors: AppColor.gradientPrimary,
        ),
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: AppColor.gradientPrimary
                .map(
                  (color) => color.withOpacity(0.2),
                )
                .toList(),
          ),
        ),
      ),
      LineChartBarData(
        spots: const [
          FlSpot(1, 0.5),
          FlSpot(2, 0.2),
          FlSpot(3, 1.2),
          FlSpot(4, 4),
          FlSpot(5, 5),
        ],
        isCurved: true,
        gradient: const LinearGradient(
          colors: AppColor.gradientOrange,
        ),
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: AppColor.gradientOrange
                .map(
                  (color) => color.withOpacity(0.2),
                )
                .toList(),
          ),
        ),
      ),
    ];
  }

  Widget bottomTitlesText(String title, BuildContext context) {
    return AppText.color(
      text: title,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      style: StyleType.labLg,
    );
  }

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta,
    BuildContext context,
  ) {
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = bottomTitlesText('Jan', context);
      case 2:
        text = bottomTitlesText('Feb', context);
      case 3:
        text = bottomTitlesText('Mar', context);
      case 4:
        text = bottomTitlesText('Apr', context);
      case 5:
        text = bottomTitlesText('May', context);
      case 6:
        text = bottomTitlesText('Jun', context);
      case 7:
        text = bottomTitlesText('Jul', context);
      case 8:
        text = bottomTitlesText('Aug', context);
      case 9:
        text = bottomTitlesText('Sep', context);
      case 10:
        text = bottomTitlesText('Oct', context);
      case 11:
        text = bottomTitlesText('Nov', context);
      case 12:
        text = bottomTitlesText('Dec', context);
      default:
        return const SizedBox();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;

    switch (value.toInt()) {
      case 0:
        text = '0';
      case 1:
        text = '10.000';
      case 2:
        text = '20.000';
      case 3:
        text = '30.000';
      case 4:
        text = '40.000';
      case 5:
        text = '50.000';
      default:
        return const SizedBox();
    }

    return AppText.color(
      text: text,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      style: StyleType.labLg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            axisNameSize: 10,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return bottomTitleWidgets(value, meta, context);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: 60,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: minX(),
        maxX: maxX(),
        minY: minY(),
        maxY: maxY(),
        lineBarsData: _lineChartBarData(),
      ),
    );
  }
}
