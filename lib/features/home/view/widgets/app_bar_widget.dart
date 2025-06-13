import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/view/controller/budget/budget_bloc.dart';
import 'package:budget_intelli/features/budget/view/controller/budgets/budgets_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  void _onBudgetSelected(String budgetId) {
    context.read<SettingBloc>().add(
          SetUserLastSeenBudgetId(lastSeenBudgetId: budgetId),
        );
    context.read<BudgetBloc>().add(
          GetBudgetsByIdEvent(
            id: budgetId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocConsumer<BudgetsCubit, BudgetsState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {},
      builder: (context, state) {
        final budgets = state.budgets;
        final budgetsNotNullOrNotEmpty = budgets != null && budgets.isNotEmpty;

        return GestureDetector(
          onTap: () async {
            final result = await showCupertinoModalPopup<String>(
              context: context,
              builder: (context) {
                if (budgetsNotNullOrNotEmpty) {
                  return CupertinoActionSheet(
                    title: AppText(
                      text: localize.selectBudget,
                      style: StyleType.headMed,
                    ),
                    actions: List.generate(
                      budgets.length,
                      (index) {
                        return CupertinoActionSheetAction(
                          onPressed: () {
                            final budgetId = budgets[index].id;
                            context.pop(budgetId);
                          },
                          child: AppText(
                            text: budgets[index].budgetName,
                            style: StyleType.bodMed,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CupertinoActionSheet(
                    title: AppText(
                      text: localize.selectBudget,
                      style: StyleType.headMed,
                    ),
                    actions: List.generate(1, (index) {
                      return CupertinoActionSheetAction(
                        onPressed: () {
                          context.pop();
                        },
                        child: AppText(
                          text: localize.noBudgetCreatedYet,
                          style: StyleType.bodMed,
                        ),
                      );
                    }),
                  );
                }
              },
            );

            if (result != null) {
              _onBudgetSelected(result);
            }
          },
          child: BlocBuilder<BudgetBloc, BudgetState>(
            builder: (context, state) {
              var name = localize.selectBudget;
              if (state is GetBudgetsLoaded) {
                name = state.budget?.budgetName ?? name;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: name,
                    style: StyleType.headMed,
                  ),
                  Gap.horizontal(8),
                  const Icon(
                    CupertinoIcons.chevron_down,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
