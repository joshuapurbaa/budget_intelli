import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/category/view/controllers/insight/insight_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PairChartMonthly extends StatefulWidget {
  const PairChartMonthly({
    super.key,
  });

  @override
  State<PairChartMonthly> createState() => _PairChartMonthlyState();
}

class _PairChartMonthlyState extends State<PairChartMonthly> {
  final Color leftBarColor = AppColor.green;
  final Color rightBarColor = AppColor.red;
  final Color avgColor = AppColor.orange;
  final double width = 10;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocBuilder<InsightCubit, InsightState>(
      builder: (context, state) {
        final monthlyIncomeMap = state.monthlyIncomeMap;
        final monthlyExpenseMap = state.monthlyExpenseMap;

        var incomeAmounts = <int>[];
        var expenseAmounts = <int>[];

        if (monthlyIncomeMap.isNotEmpty) {
          incomeAmounts = monthlyIncomeMap.values.toList();
        } else {
          incomeAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        }

        if (monthlyExpenseMap.isNotEmpty) {
          expenseAmounts = monthlyExpenseMap.values.toList();
        } else {
          expenseAmounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        }

        double? maxY;

        if (incomeAmounts.isNotEmpty && expenseAmounts.isNotEmpty) {
          final maxIncomeY = incomeAmounts
              .reduce((value, element) => value > element ? value : element)
              .toDouble();
          final maxExpenseY = expenseAmounts
              .reduce((value, element) => value > element ? value : element)
              .toDouble();

          maxY = maxIncomeY > maxExpenseY ? maxIncomeY : maxExpenseY;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    barTouchData: BarTouchData(
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
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
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
                            toY: incomeAmounts[0].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[0].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[1].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[1].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[2].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[2].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[3].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[3].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[4].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[4].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[5].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[5].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 6,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[6].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[6].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 7,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[7].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[7].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 8,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[8].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[8].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 9,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[9].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[9].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 10,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[10].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[10].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 11,
                        barRods: [
                          BarChartRodData(
                            toY: incomeAmounts[11].toDouble(),
                            color: leftBarColor,
                          ),
                          BarChartRodData(
                            toY: expenseAmounts[11].toDouble(),
                            color: rightBarColor,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
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
      },
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColor.blue,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
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
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }
}
