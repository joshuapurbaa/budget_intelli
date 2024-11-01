import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/home/home_barrel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartOverview extends StatefulWidget {
  const PieChartOverview({
    required this.groupCategoryHistories,
    required this.totalExpense,
    required this.expensesEmpty,
    super.key,
  });

  final List<GroupCategoryHistory> groupCategoryHistories;
  final int totalExpense;
  final bool expensesEmpty;

  @override
  State<StatefulWidget> createState() => _PieChartOverviewState();
}

class _PieChartOverviewState extends State<PieChartOverview> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    if (widget.expensesEmpty) {
      return Center(
        child: AppText(
          text: localize.noExpensesCategoryAdded,
          style: StyleType.bodLg,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 2.2,
      child: Row(
        children: [
          Gap.horizontal(16),
          Expanded(
            child: AspectRatio(
              aspectRatio: 0.5,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Gap.horizontal(20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.groupCategoryHistories.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          if (widget.groupCategoryHistories[i].type ==
                              AppStrings.expenseType) ...[
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color(
                                    widget.groupCategoryHistories[i].hexColor,),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                text:
                                    widget.groupCategoryHistories[i].groupName,
                                style: StyleType.bodSm,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final groups = widget.groupCategoryHistories;

    final amount = <int>[];
    final name = <String>[];
    final portion = <double>[];
    final color = <Color>[];

    for (var i = 0; i < groups.length; i++) {
      final group = groups[i];
      if (group.type == AppStrings.incomeType) {
        continue;
      }
      final itemCategories = group.itemCategoryHistories;
      var total = 0;
      for (var j = 0; j < itemCategories.length; j++) {
        final itemCategory = itemCategories[j];
        total += itemCategory.amount;
      }
      amount.add(total);
      name.add(group.groupName);
      color.add(Color(group.hexColor));
    }

    final totalExpense = amount.reduce((value, element) => value + element);

    // calculate portion of each group
    for (var i = 0; i < amount.length; i++) {
      final value = ((amount[i] / totalExpense) * 100).roundToDouble();
      portion.add(value);
    }

    final pieCharts = <PieChartSectionData>[];

    for (var i = 0; i < name.length; i++) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 55.0 : 50.0;

      final portionStr =
          '${portion[i].toStringAsFixed(2)}%'.replaceAll('.00', '');

      pieCharts.add(
        PieChartSectionData(
          color: color[i],
          value: portion[i],
          // title: name[i],
          radius: radius,
          showTitle: false,
          titleStyle: textStyle(
            context,
            StyleType.bodMd,
          ).copyWith(
            fontWeight: FontWeight.w700,
          ),
          // borderSide: BorderSide(
          //   color: context.color.primary,
          //   width: 0.3,
          //   style: BorderStyle.none,
          //   strokeAlign: 0.8,
          // ),
          badgePositionPercentageOffset: 0.5,
          badgeWidget: BadgeWidget(
            size: isTouched ? 40 : 35,
            borderColor: context.color.primary,
            child: Center(
              child: AppText.autoSize(
                text: portionStr,
                style: isTouched ? StyleType.bodSm : StyleType.labLg,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return pieCharts;
  }
}
