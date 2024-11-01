import 'package:budget_intelli/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraphWeekly extends StatefulWidget {
  const LineGraphWeekly({super.key});

  @override
  State<LineGraphWeekly> createState() => _LineGraphWeeklyState();
}

class _LineGraphWeeklyState extends State<LineGraphWeekly> {
  double minX() {
    return 1;
  }

  double maxX() {
    return 5;
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
          FlSpot(1, 0.1),
          FlSpot(2, 0.3),
          FlSpot(3, 4),
          FlSpot(4, 2),
          FlSpot(5, 3),
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
        text = bottomTitlesText('Week 1', context);
      case 2:
        text = bottomTitlesText('Week 2', context);
      case 3:
        text = bottomTitlesText('Week 3', context);
      case 4:
        text = bottomTitlesText('Week 4', context);
      case 5:
        text = bottomTitlesText('Week 5', context);

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
        text = '200';
      case 2:
        text = '500';
      case 3:
        text = '1.000';
      case 4:
        text = '2.000';
      case 5:
        text = '5.000';
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
