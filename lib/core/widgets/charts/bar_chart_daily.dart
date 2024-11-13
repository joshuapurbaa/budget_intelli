import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartDaily extends StatelessWidget {
  const BarChartDaily({
    required this.dailyAmounts,
    required this.selectedLanguage,
    super.key,
  });

  final List<double> dailyAmounts;
  final Language selectedLanguage;

  @override
  Widget build(BuildContext context) {
    double? maxY;

    if (dailyAmounts.isNotEmpty) {
      maxY = dailyAmounts
          .reduce((value, element) => value > element ? value : element);
    }

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
                toY: dailyAmounts[0],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: dailyAmounts[1],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: dailyAmounts[2],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: dailyAmounts[3],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                toY: dailyAmounts[4],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                toY: dailyAmounts[5],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(
                toY: dailyAmounts[6],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        ],
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColor.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    if (selectedLanguage == Language.english) {
      switch (value.toInt()) {
        case 0:
          text = 'Mon';
        case 1:
          text = 'Tue';
        case 2:
          text = 'Wed';
        case 3:
          text = 'Thu';
        case 4:
          text = 'Fri';
        case 5:
          text = 'Sat';
        case 6:
          text = 'Sun';
        default:
          text = '';
          break;
      }
    } else {
      switch (value.toInt()) {
        case 0:
          text = 'Sen';
        case 1:
          text = 'Sel';
        case 2:
          text = 'Rab';
        case 3:
          text = 'Kam';
        case 4:
          text = 'Jum';
        case 5:
          text = 'Sab';
        case 6:
          text = 'Min';
        default:
          text = '';
          break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
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
