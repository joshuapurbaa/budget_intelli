import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budgets_state.dart';

class BudgetsCubit extends Cubit<BudgetsState> {
  BudgetsCubit({
    required GetBudgetList getBudgetList,
  })  : _getBudgetList = getBudgetList,
        super(const BudgetsState(budgets: []));

  final GetBudgetList _getBudgetList;

  Future<List<Budget>?> getBudgets() async {
    try {
      emit(state.copyWith(loading: true));
      final budgets = await _getBudgetList(NoParams());
      var budgetList = <Budget>[];

      budgets.fold(
        (l) => emit(
          state.copyWith(
            budgets: [],
            loading: false,
          ),
        ),
        (r) {
          emit(
            state.copyWith(
              budgets: r,
              loading: false,
            ),
          );
          budgetList = r;
        },
      );

      return budgetList;
    } catch (e) {
      emit(
        state.copyWith(
          budgets: [],
          loading: false,
        ),
      );
      return null;
    }
  }
}
