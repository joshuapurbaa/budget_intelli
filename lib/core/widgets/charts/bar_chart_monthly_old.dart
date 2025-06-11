import 'dart:async';
import 'package:budget_intelli/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarCharMonthlyOld extends StatefulWidget {
  const BarCharMonthlyOld({super.key});

  @override
  State<BarCharMonthlyOld> createState() => _BarCharMonthlyOldState();
}

class _BarCharMonthlyOldState extends State<BarCharMonthlyOld> {
  @override
  Widget build(BuildContext context) {
    return const BarChartSample1();
  }
}

class BarChartSample1 extends StatefulWidget {
  const BarChartSample1({super.key});

  List<Color> get availableColors => const <Color>[
        AppColor.purple,
        AppColor.yellow,
        AppColor.blue,
        AppColor.orange,
        AppColor.pink,
        AppColor.red,
      ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 250);
  // final Color barBackgroundColor = AppColor.grayscale300.withOpacity(0.3);
  final Color barColor = AppColor.white;
  final Color touchedBarColor = AppColor.green;

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      mainBarData(),
      duration: animDuration,
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: AppColor.amber)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            // color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 10, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 1, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 3, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 2.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 4, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 2, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
              case 1:
                weekDay = 'Tuesday';
              case 2:
                weekDay = 'Wednesday';
              case 3:
                weekDay = 'Thursday';
              case 4:
                weekDay = 'Friday';
              case 5:
                weekDay = 'Saturday';
              case 6:
                weekDay = 'Sunday';
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget bottomTitlesText(String title) {
    return AppText.color(
      text: title,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      style: StyleType.labLg,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;

    switch (value.toInt()) {
      case 0:
        text = '0';
      case 1:
        text = '100';
      case 2:
        text = '150';
      case 3:
        text = '300';
      case 4:
        text = '500';
      case 5:
        text = '700';
      case 6:
        text = '1000';
      default:
        return const SizedBox();
    }

    return AppText.color(
      text: text,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      style: StyleType.labLg,
    );
  }

  Widget getBottomTitles(
    double value,
    TitleMeta meta,
  ) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = bottomTitlesText('M');
      case 1:
        text = bottomTitlesText('T');
      case 2:
        text = bottomTitlesText('W');
      case 3:
        text = bottomTitlesText('T');
      case 4:
        text = bottomTitlesText('F');
      case 5:
        text = bottomTitlesText('S');
      case 6:
        text = bottomTitlesText('S');
      default:
        text = bottomTitlesText('');
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
