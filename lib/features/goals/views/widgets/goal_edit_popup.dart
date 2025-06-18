import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GoalEditPopup extends StatefulWidget {
  const GoalEditPopup({
    required this.goal,
    required this.saved,
    super.key,
  });
  final GoalModel goal;
  final double? saved;

  @override
  State<GoalEditPopup> createState() => _GoalEditPopupState();
}

class _GoalEditPopupState extends State<GoalEditPopup> {
  final _goalNameController = TextEditingController();
  List<DateTime?> _daterange = [];
  double? _updatedGoalAmount;

  @override
  void dispose() {
    _goalNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final goal = widget.goal;
    _goalNameController.text = goal.goalName;

    final startDate = DateTime.parse(goal.startGoalDate);
    final endDate = DateTime.parse(goal.endGoalDate);

    setState(() {
      _daterange.addAll([startDate, endDate]);
      _updatedGoalAmount = goal.goalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final onSurfaceColor = context.color.onSurface.withValues(alpha: 0.5);

    final title = localize.editGoal;

    int? monthsRemaining;
    int? daysRemaining;
    double? planAmountPerMonth;
    double? planAmountPerDay;
    num? remainingAmountGoal;

    if (_daterange.isNotEmpty && _updatedGoalAmount != null) {
      daysRemaining = _daterange[1]!.difference(_daterange[0]!).inDays;

      if (_daterange[1]!.year == _daterange[1]!.year) {
        monthsRemaining = (_daterange[1]!.month - _daterange[0]!.month) + 1;
      } else {
        monthsRemaining = (_daterange[1]!.month - _daterange[0]!.month) +
            (12 * (_daterange[1]!.year - _daterange[0]!.year));
      }

      final goalAmount = _updatedGoalAmount!;
      final saved = widget.saved;

      // Hitung total amount yang perlu dicapai
      remainingAmountGoal = goalAmount - saved!;

      planAmountPerDay = remainingAmountGoal / daysRemaining;

      planAmountPerMonth = remainingAmountGoal / monthsRemaining;
    }

    return SafeArea(
      child: Material(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    text: title,
                    style: StyleType.headMed,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),
              Gap.vertical(22),
              TextField(
                controller: _goalNameController,
                textInputAction: TextInputAction.next,
                style: textStyle(
                  context,
                  style: StyleType.bodMed,
                ),
                decoration: InputDecoration(
                  labelText: localize.goalName,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  contentPadding: const EdgeInsets.all(10),
                  hintStyle: textStyle(
                    context,
                    style: StyleType.bodMed,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: context.color.onSurface.withValues(alpha: 0.1),
                  filled: true,
                ),
              ),
              Gap.vertical(22),
              AppBoxCalculator(
                label: NumberFormatter.formatToMoneyDouble(
                  context,
                  widget.goal.goalAmount,
                ),
                onValueSelected: (value) {
                  setState(() {
                    _updatedGoalAmount = value.toDouble();
                  });
                },
              ),
              Gap.vertical(16),
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
                        final width = context.screenWidth * 0.9;
                        final sixtyDayBefore =
                            DateTime.now().subtract(const Duration(days: 60));

                        final results = await showCalendarDatePicker2Dialog(
                          context: context,
                          config: CalendarDatePicker2WithActionButtonsConfig(
                            calendarType: CalendarDatePicker2Type.range,
                            firstDate: sixtyDayBefore,
                            controlsTextStyle: textStyle(
                              context,
                              style: StyleType.bodLg,
                            ),
                          ),
                          dialogSize: Size(width, 400),
                          value: _daterange,
                          borderRadius: BorderRadius.circular(15),
                        );

                        if (results != null && results.length == 2) {
                          setState(() {
                            _daterange = results;
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
                                  _daterange,
                                  context,
                                ),
                                style: StyleType.bodMed,
                                textAlign: TextAlign.center,
                                fontWeight:
                                    _daterange.isEmpty ? null : FontWeight.w700,
                                maxLines: 2,
                                color: _daterange.isEmpty
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
                  ],
                ),
              ),
              Gap.vertical(16),
              BlocListener<GoalDatabaseBloc, GoalDatabaseState>(
                listener: (context, state) {
                  if (state.updateGoalSuccess) {
                    if (context.canPop()) {
                      context.pop();
                      context
                          .read<GoalDatabaseBloc>()
                          .add(ResetGoalStateEvent());
                      context.read<GoalDatabaseBloc>().add(
                            GetGoalFromDbByIdEvent(widget.goal.id),
                          );
                      context.read<GoalDatabaseBloc>().add(
                            GetGoalsFromDbEvent(),
                          );
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: AppText(
                          text: textLocalizer(context).cancel,
                          style: StyleType.bodMed,
                        ),
                      ),
                    ),
                    Gap.horizontal(10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.color.primary,
                        ),
                        onPressed: () {
                          final goal = widget.goal;
                          if (widget.saved != null &&
                              _updatedGoalAmount != null) {
                            final remainingAmount =
                                _updatedGoalAmount! - widget.saved!;

                            final updatedGoal = GoalModel(
                              id: goal.id,
                              goalName: _goalNameController.text,
                              goalAmount: _updatedGoalAmount!,
                              startGoalDate: _daterange[0].toString(),
                              endGoalDate: _daterange[1].toString(),
                              remainingAmount: remainingAmount,
                              createdAt: goal.createdAt,
                              updatedAt: DateTime.now().toString(),
                              perDayAmount: planAmountPerDay!,
                              perMonthAmount: planAmountPerMonth!,
                            );

                            context.read<GoalDatabaseBloc>().add(
                                  UpdateGoalFromDBEvent(updatedGoal),
                                );
                          }
                        },
                        child: AppText(
                          text: textLocalizer(context).save,
                          style: StyleType.bodMed,
                          color: context.color.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap.vertical(16),
            ],
          ),
        ),
      ),
    );
  }
}
