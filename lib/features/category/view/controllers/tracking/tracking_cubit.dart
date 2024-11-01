import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit({
    required GetItemCategoryTransactionsByBudgetId
        getItemCategoryTransactionsByBudgetId,
    required GetItemCategoryHistoriesByGroupId getItemCategoriesByGroupId,
    required GetItemCategoryHistoriesByBudgetId getItemCategoriesByBudgetId,
  })  : _getItemCategoryTransactionsByBudgetId =
            getItemCategoryTransactionsByBudgetId,
        _getItemCategoriesByGroupId = getItemCategoriesByGroupId,
        _getItemCategoriesByBudgetId = getItemCategoriesByBudgetId,
        super(
          const TrackingState(
            dailyTransactions: [],
            weeklyTransactions: [],
            monthlyTransactions: [],
            yearlyTransactions: [],
            allTransactions: [],
            itemCategories: [],
          ),
        );

  final GetItemCategoryTransactionsByBudgetId
      _getItemCategoryTransactionsByBudgetId;
  final GetItemCategoryHistoriesByGroupId _getItemCategoriesByGroupId;
  final GetItemCategoryHistoriesByBudgetId _getItemCategoriesByBudgetId;

  void setToInitial() {
    emit(
      const TrackingState(
        dailyTransactions: [],
        weeklyTransactions: [],
        monthlyTransactions: [],
        yearlyTransactions: [],
        allTransactions: [],
        itemCategories: [],
      ),
    );
  }

  Future<void> getAllItemCategoryTransactionsByBudgetId(String budgetId) async {
    return _getItemCategoryTransactionsByBudgetId(budgetId).then((result) {
      return result.fold(
        (failure) {
          emit(
            state.copyWith(
              dailyTransactions: [],
              weeklyTransactions: [],
              monthlyTransactions: [],
              yearlyTransactions: [],
              allTransactions: [],
              loading: false,
            ),
          );
        },
        (transactions) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final endOfToday = DateTime(now.year, now.month, now.day, 23, 59);

          final week = today.subtract(const Duration(days: 7));
          final month = today.subtract(const Duration(days: 30));
          final year = today.subtract(const Duration(days: 365));

          final dailyTransactions = transactions
              .where(
                (element) =>
                    DateTime.parse(element.createdAt).isAfter(today) &&
                    DateTime.parse(element.createdAt).isBefore(endOfToday),
              )
              .toList();

          final weeklyTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(week) && createdAt.isBefore(endOfToday);
          }).toList();

          final monthlyTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(month) && createdAt.isBefore(endOfToday);
          }).toList();

          final yearlyTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(year) && createdAt.isBefore(endOfToday);
          }).toList();

          emit(
            state.copyWith(
              dailyTransactions: dailyTransactions,
              weeklyTransactions: weeklyTransactions,
              monthlyTransactions: monthlyTransactions,
              yearlyTransactions: yearlyTransactions,
              allTransactions: transactions,
            ),
          );
        },
      );
    });
  }

  Future<void> getItemCategoriesByGroupId(String groupId) async {
    return _getItemCategoriesByGroupId(groupId).then((result) {
      return result.fold(
        (failure) {
          emit(state.copyWith(itemCategories: []));
        },
        (itemCategories) {
          emit(state.copyWith(itemCategories: itemCategories));
        },
      );
    });
  }

  Future<void> getItemCategoriesByBudgetId(String budgetId) async {
    return _getItemCategoriesByBudgetId(budgetId).then((result) {
      return result.fold(
        (failure) {
          emit(state.copyWith(itemCategories: []));
        },
        (itemCategories) {
          emit(state.copyWith(itemCategories: itemCategories));
        },
      );
    });
  }
}
