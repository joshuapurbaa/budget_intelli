import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'insight_state.dart';

class InsightCubit extends Cubit<InsightState> {
  InsightCubit({
    required GetItemCategoryTransactionsByBudgetId
        getItemCategoryTransactionsByBudgetId,
    required GetItemCategoryHistoriesByGroupId getItemCategoriesByGroupId,
    required GetItemCategoryHistoriesByBudgetId getItemCategoriesByBudgetId,
  })  : _getItemCategoryTransactionsByBudgetId =
            getItemCategoryTransactionsByBudgetId,
        _getItemCategoriesByGroupId = getItemCategoriesByGroupId,
        _getItemCategoriesByBudgetId = getItemCategoriesByBudgetId,
        super(
          const InsightState(
            loading: false,
            itemCategories: [],
            allTransactions: [],
            weeklyTransactions: [],
            oneMonthTransactions: [],
            threeMonthTransactions: [],
            sixMonthTransactions: [],
            nineMonthTransactions: [],
            twelveMonthTransactions: [],
          ),
        );

  final GetItemCategoryTransactionsByBudgetId
      _getItemCategoryTransactionsByBudgetId;
  final GetItemCategoryHistoriesByGroupId _getItemCategoriesByGroupId;
  final GetItemCategoryHistoriesByBudgetId _getItemCategoriesByBudgetId;

  Future<void> getAllItemCategoryTransactionsByBudgetId(String budgetId) async {
    return _getItemCategoryTransactionsByBudgetId(budgetId).then((result) {
      return result.fold(
        (failure) {
          emit(
            state.copyWith(
              loading: false,
              itemCategories: [],
              allTransactions: [],
              oneMonthTransactions: [],
              threeMonthTransactions: [],
              sixMonthTransactions: [],
              nineMonthTransactions: [],
              twelveMonthTransactions: [],
            ),
          );
        },
        (transactions) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final endOfToday = today.add(const Duration(days: 1));
          final month = today.subtract(const Duration(days: 30));
          final threeMonth = today.subtract(const Duration(days: 90));
          final sixMonth = today.subtract(const Duration(days: 180));
          final nineMonth = today.subtract(const Duration(days: 270));
          final twelveMonth = today.subtract(const Duration(days: 360));

          final monthlyTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(month) && createdAt.isBefore(endOfToday);
          }).toList();

          final threeMonthTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(threeMonth) &&
                createdAt.isBefore(endOfToday);
          }).toList();

          final sixMonthTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(sixMonth) &&
                createdAt.isBefore(endOfToday);
          }).toList();

          final nineMonthTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(nineMonth) &&
                createdAt.isBefore(endOfToday);
          }).toList();

          final twelveMonthTransactions = transactions.where((element) {
            final createdAt = DateTime.parse(element.createdAt);
            return createdAt.isAfter(twelveMonth) &&
                createdAt.isBefore(endOfToday);
          }).toList();

          final onlyIncomeTransactions = transactions.where((element) {
            return element.type == 'income';
          }).toList();

          final onlyExpenseTransactions = transactions.where((element) {
            return element.type == 'expense';
          }).toList();

          final monthlyIncomeTransactionsMap =
              onlyIncomeTransactions.fold<Map<String, int>>(
            {},
            (previousValue, element) {
              final createdAt = DateTime.parse(element.createdAt);
              final monthName = kIsWeb
                  ? DateFormat('MMMM').format(createdAt)
                  : DateFormat('MMMM').format(createdAt);
              final amount = previousValue[monthName] ?? 0;
              previousValue[monthName] = amount + element.amount;
              return previousValue;
            },
          );

          final monthlyExpenseTransactionsMap =
              onlyExpenseTransactions.fold<Map<String, int>>(
            {},
            (previousValue, element) {
              final createdAt = DateTime.parse(element.createdAt);
              final monthName = kIsWeb
                  ? DateFormat('MMMM').format(createdAt)
                  : DateFormat('MMMM').format(createdAt);
              final amount = previousValue[monthName] ?? 0;
              previousValue[monthName] = amount + element.amount;
              return previousValue;
            },
          );

          final monthlyIncomeMap = {
            'Jan': monthlyIncomeTransactionsMap['January'] ?? 0,
            'Feb': monthlyIncomeTransactionsMap['February'] ?? 0,
            'Mar': monthlyIncomeTransactionsMap['March'] ?? 0,
            'Apr': monthlyIncomeTransactionsMap['April'] ?? 0,
            'May': monthlyIncomeTransactionsMap['May'] ?? 0,
            'Jun': monthlyIncomeTransactionsMap['June'] ?? 0,
            'Jul': monthlyIncomeTransactionsMap['July'] ?? 0,
            'Aug': monthlyIncomeTransactionsMap['August'] ?? 0,
            'Sep': monthlyIncomeTransactionsMap['September'] ?? 0,
            'Oct': monthlyIncomeTransactionsMap['October'] ?? 0,
            'Nov': monthlyIncomeTransactionsMap['November'] ?? 0,
            'Dec': monthlyIncomeTransactionsMap['December'] ?? 0,
          };

          final monthlyExpenseMap = {
            'Jan': monthlyExpenseTransactionsMap['January'] ?? 0,
            'Feb': monthlyExpenseTransactionsMap['February'] ?? 0,
            'Mar': monthlyExpenseTransactionsMap['March'] ?? 0,
            'Apr': monthlyExpenseTransactionsMap['April'] ?? 0,
            'May': monthlyExpenseTransactionsMap['May'] ?? 0,
            'Jun': monthlyExpenseTransactionsMap['June'] ?? 0,
            'Jul': monthlyExpenseTransactionsMap['July'] ?? 0,
            'Aug': monthlyExpenseTransactionsMap['August'] ?? 0,
            'Sep': monthlyExpenseTransactionsMap['September'] ?? 0,
            'Oct': monthlyExpenseTransactionsMap['October'] ?? 0,
            'Nov': monthlyExpenseTransactionsMap['November'] ?? 0,
            'Dec': monthlyExpenseTransactionsMap['December'] ?? 0,
          };

          emit(
            state.copyWith(
              allTransactions: transactions,
              oneMonthTransactions: monthlyTransactions,
              threeMonthTransactions: threeMonthTransactions,
              sixMonthTransactions: sixMonthTransactions,
              nineMonthTransactions: nineMonthTransactions,
              twelveMonthTransactions: twelveMonthTransactions,
              monthlyIncomeMap: monthlyIncomeMap,
              monthlyExpenseMap: monthlyExpenseMap,
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

  void filterTransactionsByCategory(String categoryId) {
    final transactions = state.allTransactions.where((element) {
      return element.itemHistoId == categoryId;
    }).toList();

    final totalTransactionAmounts = <int>[];

    // sum up the total amount of transactions for each month
    for (var i = 0; i < 12; i++) {
      final month = i + 1;
      final transactionsForMonth = transactions.where((element) {
        final createdAt = DateTime.parse(element.createdAt);
        return createdAt.month == month;
      }).toList();

      final totalAmount = transactionsForMonth.fold<int>(
        0,
        (previousValue, element) => previousValue + element.amount,
      );

      totalTransactionAmounts.add(totalAmount);
    }

    emit(
      state.copyWith(totalTransactionAmounts: totalTransactionAmounts),
    );
  }

  void filterSpendingBreakdown({required String categoryId}) {
    final transactions = state.allTransactions.where((element) {
      return element.itemHistoId == categoryId;
    }).toList();

    // daily transaction is total transaction for the day. example data ['Monday':400,'Tuesday': 200,'Wednesday': 20,'Thursday': 400,'Friday': 50,'Saturaday':600,'Sunday': 700]
    final dailyTransactions = transactions.fold<Map<String, int>>(
      {},
      (previousValue, element) {
        final createdAt = DateTime.parse(element.createdAt);
        final dayName = kIsWeb
            ? DateFormat('EEEE').format(createdAt)
            : DateFormat('EEEE').format(createdAt);
        final amount = previousValue[dayName] ?? 0;
        previousValue[dayName] = amount + element.amount;
        return previousValue;
      },
    );

    final allDayTransactions = {
      'Mn': dailyTransactions['Monday'] ?? 0,
      'Te': dailyTransactions['Tuesday'] ?? 0,
      'Wd': dailyTransactions['Wednesday'] ?? 0,
      'Tu': dailyTransactions['Thursday'] ?? 0,
      'Fr': dailyTransactions['Friday'] ?? 0,
      'St': dailyTransactions['Saturday'] ?? 0,
      'Sn': dailyTransactions['Sunday'] ?? 0,
    };

    // monthly transaction is total transaction for the month. example data ['January':400,'February': 200,'March': 20,'April': 400,'May': 50,'June':600,'July': 700,'August': 400,'September': 200,'October': 20,'November': 400,'December': 50]
    final monthlyTransactions = transactions.fold<Map<String, int>>(
      {},
      (previousValue, element) {
        final createdAt = DateTime.parse(element.createdAt);
        final monthName = kIsWeb
            ? DateFormat('MMMM').format(createdAt)
            : DateFormat('MMMM').format(createdAt);
        final amount = previousValue[monthName] ?? 0;
        previousValue[monthName] = amount + element.amount;
        return previousValue;
      },
    );

    final allMonthTransactions = {
      'Jan': monthlyTransactions['January'] ?? 0,
      'Feb': monthlyTransactions['February'] ?? 0,
      'Mar': monthlyTransactions['March'] ?? 0,
      'Apr': monthlyTransactions['April'] ?? 0,
      'May': monthlyTransactions['May'] ?? 0,
      'Jun': monthlyTransactions['June'] ?? 0,
      'Jul': monthlyTransactions['July'] ?? 0,
      'Aug': monthlyTransactions['August'] ?? 0,
      'Sep': monthlyTransactions['September'] ?? 0,
      'Oct': monthlyTransactions['October'] ?? 0,
      'Nov': monthlyTransactions['November'] ?? 0,
      'Dec': monthlyTransactions['December'] ?? 0,
    };

    // yearly transaction is total transaction for the year. example data ['2021':400,'2022': 200,'2023': 20,'2024': 400,'2025': 50] but we are going to use the current year and dynamically add new year as the year goes by
    final yearlyTransactions = transactions.fold<Map<String, int>>(
      {},
      (previousValue, element) {
        final createdAt = DateTime.parse(element.createdAt);
        final year = createdAt.year.toString();
        final amount = previousValue[year] ?? 0;
        previousValue[year] = amount + element.amount;
        return previousValue;
      },
    );

    emit(
      state.copyWith(
        dailyTransactions: allDayTransactions,
        monthlyTransactions: allMonthTransactions,
        yearlyTransactions: yearlyTransactions,
      ),
    );
  }

  void setSelectedFrequency(String frequency) {
    emit(
      state.copyWith(selectedFrequency: frequency),
    );
  }
}
