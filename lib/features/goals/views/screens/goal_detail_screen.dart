import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageVal = ControllerHelper.getLanguage(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final localize = textLocalizer(context);
    return BlocConsumer<GoalDatabaseBloc, GoalDatabaseState>(
      listener: (context, state) {
        if (state.deleteGoalSuccess) {
          if (context.canPop()) {
            context.pop();
            context.read<GoalDatabaseBloc>().add(ResetGoalStateEvent());
            context.read<GoalDatabaseBloc>().add(GetGoalsFromDbEvent());
          }
        }
      },
      builder: (context, state) {
        final goal = state.goal;
        String? savedStr;
        String? goalAmountStr;
        var remainingDayStr = '';
        String? endDateStr;
        double? percentage;
        String? percetageStr;
        String? suggestedDailyAmount;
        String? suggestedMonthlyAmount;
        double? planAmountPerMonth;
        double? saved;

        if (goal != null) {
          final goalAmount = goal.goalAmount;
          final remainingAmount = goal.remainingAmount;

          saved = goalAmount - remainingAmount;

          percentage = saved / goalAmount;
          percetageStr = '${(percentage * 100).toInt()}%';

          if (percentage > 1) {
            percentage = 1.0;
          }

          savedStr = NumberFormatter.formatToMoneyDouble(
            context,
            saved,
          );

          goalAmountStr = NumberFormatter.formatToMoneyDouble(
            context,
            goalAmount,
          );

          final startDate = goal.startGoalDate.toDateTime();
          final endDate = goal.endGoalDate.toDateTime();

          endDateStr = DateFormat.yMMMMd(languageVal).format(endDate);
          final now = DateTime.now();

          if (startDate.isAfter(now)) {
            remainingDayStr = 'Not started';
          } else {
            remainingDayStr = '${endDate.difference(now).inDays} days to go';
          }

          int monthsRemaining;
          int daysRemaining;

          daysRemaining = endDate.difference(startDate).inDays;

          if (endDate.year == startDate.year) {
            monthsRemaining = (endDate.month - startDate.month) + 1;
          } else {
            monthsRemaining =
                (12 - startDate.month + 1) + (12 - (12 - endDate.month));
          }

          suggestedDailyAmount = NumberFormatter.formatToMoneyDouble(
            context,
            remainingAmount / daysRemaining,
          );

          // Hitung plan amount per bulan
          planAmountPerMonth = remainingAmount / monthsRemaining;

          suggestedMonthlyAmount = NumberFormatter.formatToMoneyDouble(
            context,
            planAmountPerMonth,
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(
                        color: context.color.primaryContainer,
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        child: ColoredBox(
                          color: context.color.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Gap.vertical(25),
                                AppText(
                                  text: goal?.goalName ?? '-',
                                  style: StyleType.disSm,
                                ),
                                Gap.vertical(16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: context.color.onInverseSurface,
                                  ),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: 'Your Target',
                                            style: StyleType.bodSm,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          AppText(
                                            text: 'Target Date',
                                            style: StyleType.bodSm,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      Gap.vertical(8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: goalAmountStr ?? '-',
                                            style: StyleType.bodLg,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          AppText(
                                            text: endDateStr ?? '-',
                                            style: StyleType.bodLg,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                      Gap.vertical(5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const AppText(
                                            text: '',
                                            style: StyleType.bodSm,
                                          ),
                                          AppText(
                                            text: remainingDayStr,
                                            style: StyleType.bodSm,
                                            fontStyle: FontStyle.italic,
                                            color: context.color.onSurface
                                                .withValues(alpha: 0.5),
                                          ),
                                        ],
                                      ),
                                      Gap.vertical(16),
                                      LinearProgressIndicator(
                                        value: percentage,
                                        minHeight: 15,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      Gap.vertical(8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: 'Saved: $savedStr',
                                            style: StyleType.bodSm,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          AppText(
                                            text: percetageStr ?? '-',
                                            style: StyleType.bodSm,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                      if (suggestedMonthlyAmount != null) ...[
                                        Gap.vertical(16),
                                        AppBoxBorder(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text:
                                                    '${localize.suggested} 💡',
                                                style: StyleType.bodMed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Gap.vertical(10),
                                              AppText(
                                                text:
                                                    '${localize.toHitYourGoalOn}  $suggestedDailyAmount per day or $suggestedMonthlyAmount ${localize.perMonth} ',
                                                style: StyleType.bodSm,
                                                noMaxLines: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Gap.vertical(32),
                                AppButton.outlined(
                                  label: localize.delete,
                                  onPressed: () async {
                                    final title = localize.deleteGoal;
                                    final contentText = localize.confirmDelete;
                                    final result =
                                        await AppDialog.showConfirmationDelete(
                                      context,
                                      title,
                                      contentText,
                                    );
                                    if (result != null) {
                                      final id = goal?.id;

                                      if (context.mounted) {
                                        _onDeleteGoal(
                                          context,
                                          id,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn() // uses `Animate.defaultDuration`
                            .scale() // inherits duration from fadeIn
                            .move(
                              delay: 300.ms,
                              duration: 600.ms,
                            ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: getPngAsset(
                        taget3dPng,
                        width: 90,
                        height: 90,
                      ),
                    )
                        .animate()
                        .flip() // uses `Animate.defaultDuration`
                        .scale() // inherits duration from fadeIn
                        .move(
                          delay: 300.ms,
                          duration: 600.ms,
                        ),
                    Positioned(
                      top: statusBarHeight + 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: const Icon(
                              CupertinoIcons.arrow_left_circle_fill,
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (goal != null) {
                                showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (context) {
                                    return GoalEditPopup(
                                      goal: goal,
                                      saved: saved,
                                    );
                                  },
                                );
                              }
                            },
                            child: const Icon(
                              Icons.edit,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onDeleteGoal(BuildContext context, String? id) {
    if (id != null) {
      context.read<GoalDatabaseBloc>().add(DeleteGoalByIdFromDbEvent(id));
    }
  }
}
