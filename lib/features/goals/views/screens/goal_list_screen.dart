import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalListScreen extends StatefulWidget {
  const GoalListScreen({super.key});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Scaffold(
      body: BlocBuilder<GoalDatabaseBloc, GoalDatabaseState>(
        builder: (context, state) {
          final goals = state.goals;
          return CustomScrollView(
            slivers: [
              const SliverAppBarPrimary(
                title: 'Goals',
              ),
              if (goals.isEmpty) ...[
                SliverToBoxAdapter(
                  child: AppGlass(
                    onTap: () {
                      context.pushNamed(
                        MyRoute.addGoal.noSlashes(),
                      );
                    },
                    margin: getEdgeInsetsAll(16),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.add,
                        ),
                        Gap.horizontal(16),
                        AppText(
                          text: localize.addGoal,
                          style: StyleType.bodMed,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (goals.isNotEmpty) ...[
                SliverFillRemaining(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: goals.length,
                              itemBuilder: (context, index) {
                                final goal = goals[index];

                                final saved =
                                    goal.goalAmount - goal.remainingAmount;

                                final savedStr =
                                    NumberFormatter.formatToMoneyDouble(
                                  context,
                                  saved,
                                );

                                final goalAmountStr =
                                    NumberFormatter.formatToMoneyDouble(
                                  context,
                                  goal.goalAmount,
                                );

                                final startDate =
                                    goal.startGoalDate.toDateTime();
                                final endDate = goal.endGoalDate.toDateTime();
                                final now = DateTime.now();
                                var remainingDays = '';

                                if (startDate.isAfter(now)) {
                                  remainingDays = localize.notStarted;
                                } else {
                                  remainingDays =
                                      '${endDate.difference(now).inDays} ${localize.daysToGo}';
                                }

                                return GestureDetector(
                                  onTap: () {
                                    context.read<GoalDatabaseBloc>().add(
                                          GetGoalFromDbByIdEvent(goal.id),
                                        );

                                    context.pushNamed(
                                      MyRoute.detailGoal.noSlashes(),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      AppGlass(
                                        padding: getEdgeInsets(
                                            left: 32,
                                            top: 22,
                                            right: 16,
                                            bottom: 16),
                                        margin: getEdgeInsets(
                                            left: 30,
                                            top: 16,
                                            right: 16,
                                            bottom: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: AppText(
                                                          text: goal.goalName,
                                                          style:
                                                              StyleType.bodMed,
                                                          maxLines: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Gap.horizontal(10),
                                                      AppText(
                                                        text: remainingDays,
                                                        style: StyleType.bodSm,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            context.color.error,
                                                      ),
                                                    ],
                                                  ),
                                                  Gap.vertical(4),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: savedStr,
                                                          style: textStyle(
                                                            context,
                                                            style:
                                                                StyleType.bodSm,
                                                          ).copyWith(
                                                            color: context
                                                                .color.primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              ' ${localize.ofLocalize} $goalAmountStr ${localize.saved}',
                                                          style: textStyle(
                                                            context,
                                                            style:
                                                                StyleType.bodSm,
                                                          ).copyWith(
                                                            color: context
                                                                .color.onSurface
                                                                .withValues(
                                                              alpha: 0.6,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Gap.horizontal(10),
                                            AppAnimatedContainer(
                                              onTap: () {
                                                context.pushNamed(
                                                  MyRoute.detailGoal
                                                      .noSlashes(),
                                                );
                                              },
                                              child: getSvgAsset(
                                                chevronRight,
                                                width: 16,
                                                height: 16,
                                                color: context.color.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 16,
                                        child: CircularPercentIndicator(
                                          radius: 28,
                                          lineWidth: 8,
                                          center: getPngAsset(
                                            goalsPng,
                                            color: context.color.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const AppDivider(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                              ),
                            ),
                          ),
                          Gap.vertical(100),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: BottomSheetParent(
                            isWithBorderTop: true,
                            child: AppButton(
                              label: localize.addGoal,
                              onPressed: () {
                                context.pushNamed(
                                  MyRoute.addGoal.noSlashes(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _getData() {
    context.read<GoalDatabaseBloc>().add(
          GetGoalsFromDbEvent(),
        );
  }
}
