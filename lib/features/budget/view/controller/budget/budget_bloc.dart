import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc({
    required GetGroupCategoryHistoriesUsecase getGroupCategoryHistoryUsecase,
    required GetBudgetsById getBudgetsFromDB,
    required UpdateBudgetUsecase updateBudgetDB,
    required GetItemCategoryTransactionsByBudgetId
        getItemCategoryTransactionsByBudgetId,
    required UpdateGroupCategoryHistoryUsecase updateGroupCategoryHistory,
  })  : _getGroupCategoryHistoryUsecase = getGroupCategoryHistoryUsecase,
        _getBudgetsFromDB = getBudgetsFromDB,
        _updateBudgetDB = updateBudgetDB,
        _getItemCategoryTransactionsByBudgetId =
            getItemCategoryTransactionsByBudgetId,
        _updateGroupCategoryHistory = updateGroupCategoryHistory,
        super(BudgetInitial()) {
    on<BudgetEvent>((event, emit) => BudgetLoading());
    on<GetGroupBudgetCategoryHistory>(_onGetGroupBudgetCategory);
    on<GetBudgetsByIdEvent>(_onGetBudgetsById);
    on<UpdateBudgetDBEvent>(_onUpdateBudgetDB);
    on<BudgetBlocInitial>(_setToInitial);
    on<UpdateGroupCategoryHistoryEvent>(_onUpdateGroupCategoryHistory);
  }

  final GetGroupCategoryHistoriesUsecase _getGroupCategoryHistoryUsecase;
  final GetBudgetsById _getBudgetsFromDB;
  final UpdateBudgetUsecase _updateBudgetDB;
  final GetItemCategoryTransactionsByBudgetId
      _getItemCategoryTransactionsByBudgetId;
  final UpdateGroupCategoryHistoryUsecase _updateGroupCategoryHistory;

  void _setToInitial(
    BudgetBlocInitial event,
    Emitter<BudgetState> emit,
  ) {
    emit(BudgetInitial());
  }

  Future<void> _onGetGroupBudgetCategory(
    GetGroupBudgetCategoryHistory event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final result = await _getGroupCategoryHistoryUsecase(NoParams());

      result.fold(
        (failure) => emit(BudgetError(failure: failure)),
        (groupCategoryList) => emit(
          GetGroupBudgetLoaded(groupCategoryList: groupCategoryList),
        ),
      );
    } catch (e) {
      emit(
        BudgetError(failure: DatabaseFailure('Db failure: $e')),
      );
    }
  }

  Future<void> _onGetBudgetsById(
    GetBudgetsByIdEvent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final result = await _getBudgetsFromDB(event.id);
      final resultGetTransactions =
          await _getItemCategoryTransactionsByBudgetId(event.id);
      var totalActualExpense = 0;
      var totalActualIncome = 0;

      result.fold(
        (error) => emit(BudgetError(failure: error)),
        (budget) {
          resultGetTransactions.fold(
              (error) => emit(BudgetError(failure: error)), (transactions) {
            if (transactions.isEmpty) {
              totalActualExpense = 0;
            } else {
              final expenseTransaction = transactions
                  .where((element) => element.type == 'expense')
                  .toList();
              // sum all the amount of the expense transaction
              totalActualExpense = expenseTransaction.fold(
                0,
                (previousValue, element) => previousValue + element.amount,
              );

              final incomeTransaction = transactions
                  .where((element) => element.type == 'income')
                  .toList();

              // sum all the amount of the income transaction
              totalActualIncome = incomeTransaction.fold(
                0,
                (previousValue, element) => previousValue + element.amount,
              );
            }

            emit(
              GetBudgetsLoaded(
                budget: budget,
                totalActualExpense: totalActualExpense,
                totalActualIncome: totalActualIncome,
                itemCategoryTransactionsByBudgetId: transactions,
              ),
            );
          });
        },
      );
    } catch (e) {
      emit(
        BudgetError(failure: DatabaseFailure('Db failure: $e')),
      );
    }
  }

  Future<void> _onUpdateBudgetDB(
    UpdateBudgetDBEvent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final result = await _updateBudgetDB(event.budget);

      result.fold(
        (failure) => emit(BudgetError(failure: failure)),
        (_) => emit(
          BudgetUpdated(),
        ),
      );
    } catch (e) {
      emit(
        BudgetError(failure: DatabaseFailure('Db failure: $e')),
      );
    }
  }

  Future<void> _onUpdateGroupCategoryHistory(
    UpdateGroupCategoryHistoryEvent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      final result =
          await _updateGroupCategoryHistory(event.groupCategoryHistory);

      result.fold(
        (failure) => null,
        (_) => emit(SuccessUpdateGroupCategoryHistory()),
      );
    } catch (e) {
      emit(
        BudgetError(
          failure: DatabaseFailure('Db failure: $e'),
        ),
      );
    }
  }
}
