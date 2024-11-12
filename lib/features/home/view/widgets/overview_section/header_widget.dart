import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
    _getGoalList();
    _getScheduledPayments();
  }

  @override
  Widget build(BuildContext context) {
    final goals = context.select((GoalDatabaseBloc bloc) => bloc.state.goals);
    final schedulePayments = context
        .select((SchedulePaymentDbBloc bloc) => bloc.state.schedulePayments);

    if (goals.isEmpty && schedulePayments.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: getEdgeInsets(
        left: 16,
        top: 10,
        right: 16,
        bottom: 10,
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          if (goals.isNotEmpty)
            AppBoxBorder(
              padding: getEdgeInsetsAll(10),
              onTap: () => context.pushNamed(
                MyRoute.goalList.noSlashes(),
              ),
              child: Row(
                children: [
                  getPngAsset(
                    taget3dPng,
                    width: 30,
                    height: 30,
                  ),
                  Gap.horizontal(10),
                  const AppText(
                    text: 'Goals',
                    style: StyleType.bodMd,
                  ),
                  Container(
                    padding:
                        getEdgeInsets(left: 5, right: 5, top: 2, bottom: 2),
                    margin: getEdgeInsets(left: 5, right: 10),
                    decoration: BoxDecoration(
                      color: context.color.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      text: goals.length.toString(),
                      style: StyleType.bodSm,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: context.color.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          if (schedulePayments.isNotEmpty)
            AppBoxBorder(
              padding: getEdgeInsetsAll(10),
              onTap: () => context.pushNamed(
                MyRoute.schedulePaymentsList.noSlashes(),
              ),
              child: Row(
                children: [
                  getPngAsset(
                    schedulePayment,
                    width: 30,
                    height: 30,
                    color: context.color.onSurface,
                  ),
                  Gap.horizontal(10),
                  const AppText(
                    text: 'Scheduled Payments',
                    style: StyleType.bodMd,
                  ),
                  Container(
                    padding:
                        getEdgeInsets(left: 5, right: 5, top: 2, bottom: 2),
                    margin: getEdgeInsets(left: 5, right: 10),
                    decoration: BoxDecoration(
                      color: context.color.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      text: schedulePayments.length.toString(),
                      style: StyleType.bodSm,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: context.color.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _getGoalList() {
    context.read<GoalDatabaseBloc>().add(
          GetGoalsFromDbEvent(),
        );
  }

  void _getScheduledPayments() {
    context.read<SchedulePaymentDbBloc>().add(
          GetSchedulePaymentsFromDb(),
        );
  }
}
