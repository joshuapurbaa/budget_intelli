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
                          style: StyleType.bodMd,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (goals.isNotEmpty) ...[
                SliverList.separated(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];

                    final saved = goal.goalAmount - goal.remainingAmount;

                    final savedStr = NumberFormatter.formatToMoneyDouble(
                      context,
                      saved,
                    );

                    final goalAmountStr = NumberFormatter.formatToMoneyDouble(
                      context,
                      goal.goalAmount,
                    );

                    final startDate = goal.startGoalDate.toDateTime();
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
                      child: Padding(
                        padding: getEdgeInsetsAll(16),
                        child: Row(
                          children: [
                            CircularPercentIndicator(
                              radius: 30,
                              lineWidth: 8,
                              center: getPngAsset(
                                goalsPng,
                                color: context.color.onSurface,
                              ),
                            ),
                            Gap.horizontal(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppText(
                                          text: goal.goalName,
                                          style: StyleType.bodLg,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Gap.horizontal(10),
                                      AppText(
                                        text: remainingDays,
                                        style: StyleType.bodMd,
                                        fontWeight: FontWeight.bold,
                                        color: context.color.error,
                                      ),
                                    ],
                                  ),
                                  AppText(
                                    text:
                                        '$savedStr ${localize.ofLocalize} $goalAmountStr ${localize.saved}',
                                    style: StyleType.bodMd,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const AppDivider(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      bottomSheet: BottomSheetParent(
        isWithBorderTop: true,
        child: AppButton(
          label: localize.addGoal,
          onPressed: () async {
            final result = await context.pushNamed(
              MyRoute.addGoal.noSlashes(),
            );

            if (result != null) {
              _getData();
            }
          },
        ),
      ),
    );
  }

  void _getData() {
    context.read<GoalDatabaseBloc>().add(
          GetGoalsFromDbEvent(),
        );
  }
}
