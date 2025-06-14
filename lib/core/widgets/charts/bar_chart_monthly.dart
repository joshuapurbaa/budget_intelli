import 'package:budget_intelli/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartMonthly extends StatelessWidget {
  const BarChartMonthly({
    required this.monthlyAmounts,
    super.key,
  });

  final List<double> monthlyAmounts;

  @override
  Widget build(BuildContext context) {
    double? maxY;

    if (monthlyAmounts.isNotEmpty) {
      maxY = monthlyAmounts
          .reduce((value, element) => value > element ? value : element);
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
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
                getTitlesWidget: getTitles,
              ),
            ),
            leftTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[0],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[1],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[2],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[3],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[4],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[5],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[6],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 7,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[7],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 8,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[8],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 9,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[9],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 10,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[10],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 11,
              barRods: [
                BarChartRodData(
                  toY: monthlyAmounts[11],
                  gradient: _barsGradient,
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          ],
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceBetween,
          maxY: maxY,
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
      case 1:
        text = 'Feb';
      case 2:
        text = 'Mar';
      case 3:
        text = 'Apr';
      case 4:
        text = 'May';
      case 5:
        text = 'Jun';
      case 6:
        text = 'Jul';
      case 7:
        text = 'Aug';
      case 8:
        text = 'Sep';
      case 9:
        text = 'Oct';
      case 10:
        text = 'Nov';
      case 11:
        text = 'Dec';
      default:
        text = '';
    }
    return SideTitleWidget(
      meta: meta,
      space: 1,
      child: AppText(
        text: text,
        style: StyleType.bodSm,
      ),
    );
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
