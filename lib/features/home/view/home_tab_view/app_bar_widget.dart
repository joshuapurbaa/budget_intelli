import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/view/controller/budget/budget_bloc.dart';
import 'package:budget_intelli/features/budget/view/controller/budgets/budgets_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    this.showAmount = false,
    super.key,
  });

  final bool showAmount;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
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

        return Stack(
          children: [
            GestureDetector(
              onTap: () async {
                final selectedBudgetId = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground
                            .resolveFrom(context),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: AppText(
                                text: localize.selectBudget,
                                style: StyleType.headMed,
                              ),
                            ),
                            const AppDivider(),
                            if (budgetsNotNullOrNotEmpty) ...[
                              ...List.generate(
                                budgets.length,
                                (index) {
                                  return CupertinoButton(
                                    onPressed: () {
                                      final budgetId = budgets[index].id;
                                      context.pop(budgetId);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: AppText(
                                        text: budgets[index].budgetName,
                                        style: StyleType.bodMed,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ] else ...[
                              CupertinoButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: AppText(
                                    text: localize.noBudgetCreatedYet,
                                    style: StyleType.bodMed,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                            Gap.vertical(16),
                          ],
                        ),
                      ),
                    );
                  },
                );

                if (selectedBudgetId != null) {
                  _onBudgetSelected(selectedBudgetId);
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
                        size: 18,
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: 5,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  context.read<SettingBloc>().add(
                        UpdateShowAmountEvent(
                          showAmount: !widget.showAmount,
                        ),
                      );
                },
                child: Icon(
                  widget.showAmount
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash,
                  size: 22,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
