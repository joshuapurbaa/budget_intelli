import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/net_worth_barrel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetWorthLineChart extends StatefulWidget {
  const NetWorthLineChart({
    required this.assetList, required this.liabilityList, super.key,
  });

  final List<AssetEntity> assetList;
  final List<LiabilityEntity> liabilityList;

  @override
  State<NetWorthLineChart> createState() => _NetWorthLineChartState();
}

class _NetWorthLineChartState extends State<NetWorthLineChart> {
  List<Color> gradientColors = [
    AppColor.cyan,
    AppColor.blue,
  ];

  @override
  Widget build(BuildContext context) {
    final totalMonthlyAssetAmountList = <double>[];
    final totalMonthlyLiabilityAmountList = <double>[];
    final monthlyNetWorthAmount = <double>[];

    // sum up total asset amount per month, the format should be like this:
    // [0,0,0,0,0,0,0,0,0,0,0,0], if there is no data for that month then it should be 0. the length should be 12
    for (var i = 0; i < 12; i++) {
      var totalAssetAmount = 0.0;
      var totalLiabilityAmount = 0.0;

      for (final asset in widget.assetList) {
        final createdAt = DateTime.parse(asset.createdAt);
        if (createdAt.month == i + 1) {
          totalAssetAmount += asset.amount;
        }
      }

      for (final liability in widget.liabilityList) {
        final createdAt = DateTime.parse(liability.createdAt);
        if (createdAt.month == i + 1) {
          totalLiabilityAmount += liability.amount;
        }
      }

      totalMonthlyAssetAmountList.add(totalAssetAmount);
      totalMonthlyLiabilityAmountList.add(totalLiabilityAmount);
      monthlyNetWorthAmount.add(totalAssetAmount - totalLiabilityAmount);
    }

    final maxY = monthlyNetWorthAmount
        .reduce((value, element) => value > element ? value : element);

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
              reservedSize: 30,
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
                toY: monthlyNetWorthAmount[0],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[1],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[2],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[3],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[4],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[5],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[6],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 7,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[7],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 8,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[8],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 9,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[9],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 10,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[10],
                gradient: _barsGradient,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 11,
            barRods: [
              BarChartRodData(
                toY: monthlyNetWorthAmount[11],
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

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppColor.blue,
          AppColor.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColor.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
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
