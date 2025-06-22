import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _goalNameController = TextEditingController();
  List<DateTime?> dateRange = [];
  String? _suggestedMonthlyAmount;
  String? _suggestedDailyAmount;
  double? _goalAmount;
  String? _startingBalance;

  final _goalNameFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    double? planAmountPerMonth;
    double? planAmountPerDay;
    num? remainingAmountGoal;
    final currentDate = DateTime.now();
    var daysRemaining = 0;
    var monthsRemaining = 0;

    if (dateRange.isNotEmpty &&
        _goalAmount != null &&
        _startingBalance != null) {
      final startDate = dateRange[0];
      final endDate = dateRange[1];

      final goalAmount = _goalAmount!;

      final startingBalance = _startingBalance!.toDouble();

      // Hitung total amount yang perlu dicapai
      remainingAmountGoal = goalAmount - startingBalance;

      // Hitung bulan yang tersisa dalam tahun
      daysRemaining = endDate!.difference(startDate!).inDays;

      if (endDate.year == startDate.year) {
        monthsRemaining = (endDate.month - startDate.month) + 1;
      } else {
        monthsRemaining =
            (12 - startDate.month + 1) + (12 - (12 - endDate.month));
      }
      planAmountPerDay = remainingAmountGoal / daysRemaining;

      _suggestedDailyAmount = NumberFormatter.formatToMoneyDouble(
        context,
        planAmountPerDay,
      );

      // Hitung plan amount per bulan
      planAmountPerMonth = remainingAmountGoal / monthsRemaining;

      _suggestedMonthlyAmount = NumberFormatter.formatToMoneyDouble(
        context,
        planAmountPerMonth,
      );
    }

    final onSurfaceColor = context.color.onSurface.withValues(alpha: 0.5);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title: localize.goal,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  AppBoxFormField(
                    hintText: '${localize.goalName}*',
                    prefixIcon: goalsPng,
                    controller: _goalNameController,
                    focusNode: _goalNameFocusNode,
                    isPng: true,
                    iconColor: context.color.onSurface,
                  ),
                  Gap.vertical(10),
                  AppBoxCalculator(
                    label: '${localize.goalAmount}*',
                    onValueSelected: (value) {
                      setState(() {
                        _goalAmount = value.toDouble();
                      });
                    },
                  ),
                  Gap.vertical(10),
                  AppBoxCalculator(
                    label: '${localize.startingBalance}*',
                    onValueSelected: (value) {
                      setState(() {
                        _startingBalance = value;
                      });
                    },
                  ),
                  Gap.vertical(10),
                  AppBoxBorder(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text:
                              '${localize.goalDate} (${localize.selectGoalPeriod})',
                          style: StyleType.bodMed,
                          fontWeight: FontWeight.bold,
                        ),
                        Gap.vertical(10),
                        GestureDetector(
                          onTap: () async {
                            final now = DateTime.now();
                            final width = context.screenWidth * 0.9;

                            final results = await showCalendarDatePicker2Dialog(
                              context: context,
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                calendarType: CalendarDatePicker2Type.range,
                                firstDate: now,
                                controlsTextStyle: textStyle(
                                  context,
                                  style: StyleType.bodLg,
                                ),
                              ),
                              dialogSize: Size(width, 400),
                              value: dateRange,
                              borderRadius: BorderRadius.circular(15),
                            );

                            if (results != null && results.length == 2) {
                              setState(() {
                                dateRange = results;
                              });
                            }
                          },
                          child: AppGlass(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: AppText(
                                    text: formatDateRangeDateList(
                                      dateRange,
                                      context,
                                    ),
                                    style: StyleType.bodMed,
                                    textAlign: TextAlign.center,
                                    fontWeight: dateRange.isEmpty
                                        ? null
                                        : FontWeight.w700,
                                    maxLines: 2,
                                    color: dateRange.isEmpty
                                        ? onSurfaceColor
                                        : context.color.onSurface,
                                  ),
                                ),
                                Gap.horizontal(10),
                                const Icon(
                                  CupertinoIcons.chevron_down_circle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap.vertical(10),
                        // duration of goals
                        AppText(
                          text:
                              '${localize.yourGoalDurationIs} $daysRemaining ${localize.days} ${localize.orText} $monthsRemaining ${localize.month}',
                          style: StyleType.bodSm,
                        ),
                      ],
                    ),
                  ),
                  Gap.vertical(10),
                  if (_suggestedMonthlyAmount != null) ...[
                    AppBoxBorder(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: '${localize.suggested} 💡',
                            style: StyleType.bodMed,
                            fontWeight: FontWeight.bold,
                          ),
                          Gap.vertical(10),
                          AppText(
                            text:
                                '${localize.toHitYourGoalOn}  $_suggestedDailyAmount ${localize.perDayOr} $_suggestedMonthlyAmount ${localize.perMonth} ',
                            style: StyleType.bodSm,
                            noMaxLines: true,
                          ),
                        ],
                      ),
                    ),
                    Gap.vertical(10),
                  ],
                  // AppBoxBorder(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       AppText.medium16(
                  //         text: localize.assignToCurrentBudget,
                  //       ),
                  //       Switch(
                  //         value: _assignToCurrentBudget,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _assignToCurrentBudget = !_assignToCurrentBudget;
                  //           });
                  //         },
                  //         activeColor: context.color.primary,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Gap.vertical(32),
                  BlocListener<GoalDatabaseBloc, GoalDatabaseState>(
                    listener: (context, state) {
                      if (state.insertGoalSuccess == true) {
                        if (context.canPop()) {
                          context.pop();
                          context
                              .read<GoalDatabaseBloc>()
                              .add(ResetGoalStateEvent());
                          context
                              .read<GoalDatabaseBloc>()
                              .add(GetGoalsFromDbEvent());
                        }
                      }
                    },
                    child: AppButton(
                      label: localize.save,
                      onPressed: () {
                        if (dateRange.isNotEmpty &&
                            _goalAmount != null &&
                            _startingBalance != null &&
                            remainingAmountGoal != null &&
                            _goalNameController.text.isNotEmpty) {
                          final goal = GoalModel(
                            id: const Uuid().v1(),
                            goalName: _goalNameController.text,
                            goalAmount: _goalAmount!,
                            startGoalDate: dateRange[0].toString(),
                            endGoalDate: dateRange[1].toString(),
                            remainingAmount: remainingAmountGoal.toDouble(),
                            createdAt: currentDate.toString(),
                            updatedAt: currentDate.toString(),
                            perDayAmount: planAmountPerDay!,
                            perMonthAmount: planAmountPerMonth!,
                          );

                          context
                              .read<GoalDatabaseBloc>()
                              .add(InsertGoalToDbEvent(goal));
                        } else {
                          AppToast.showToastError(
                            context,
                            localize.pleaseFillAllRequiredFields,
                          );
                        }
                      },
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

  int getMonthNumber(String monthAbbreviation, List<String> monthList) {
    final monthNumber = monthList.indexOf(monthAbbreviation) + 1;
    return monthNumber > 0 ? monthNumber : -1;
  }
}
