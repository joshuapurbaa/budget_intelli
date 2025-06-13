import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ButtonAddBudget extends StatelessWidget {
  const ButtonAddBudget({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Center(
      child: GestureDetector(
        onTap: () {
          context.read<BudgetFormBloc>().add(
                BudgetFormToInitial(),
              );

          context.pushNamed(
            MyRoute.addNewBudgetScreen.noSlashes(),
          );
        },
        child: AppGlass(
          margin: getEdgeInsets(left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox(),
              ),
              Icon(
                CupertinoIcons.add,
                color: context.color.primary,
              ),
              Gap.horizontal(10),
              Expanded(
                flex: 2,
                child: AppText(
                  text: localize.newBudget,
                  style: StyleType.bodMed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
