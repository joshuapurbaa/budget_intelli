import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'financial_dashboard_state.dart';

class FinancialDashboardCubit extends Cubit<FinancialDashboardState> {
  FinancialDashboardCubit({
    required GetAllFinancialTransactionByMonthAndYearDb
        getAllFinancialTransactionByMonthAndYearDb,
  })  : _getAllFinancialTransactionByMonthAndYearDb =
            getAllFinancialTransactionByMonthAndYearDb,
        super(FinancialDashboardState());

  final GetAllFinancialTransactionByMonthAndYearDb
      _getAllFinancialTransactionByMonthAndYearDb;

  void selectMonth({
    required String month,
    required String monthNumStr,
  }) {
    emit(
      state.copyWith(
        selectedMonth: month,
        monthNumStr: monthNumStr,
      ),
    );
  }

  void toggleIncome({required bool isIncome}) {
    emit(
      state.copyWith(
        isIncome: isIncome,
      ),
    );
  }

  Future<void> getAllFinancialTransactionByMonthAndYear(
    BuildContext context, {
    String? namaBulan,
    String? monthStr,
  }) async {
    String? monthNumber;

    if (namaBulan != null) {
      monthNumber = getBulanDariNama(namaBulan, context);
    } else {
      monthNumber = monthStr;
    }

    if (monthNumber != null) {
      final result = await _getAllFinancialTransactionByMonthAndYearDb(
        MonthYearParams(
          month: monthNumber,
          year: DateTime.now().year.toString(),
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(monthTransactions: []),
        ),
        (transactions) {
          emit(
            state.copyWith(
              monthTransactions: transactions,
            ),
          );
          _getAndCalculateTransactions(transactions);
        },
      );
    } else {
      emit(
        state.copyWith(monthTransactions: []),
      );
    }
  }

  List<FinancialTransaction> getTodayTransactions(
    List<FinancialTransaction> transactions,
  ) {
    final today = DateTime.now();
    final todayStr = today.toString().substring(0, 10);

    var todayTransactions = <FinancialTransaction>[];

    if (transactions.isNotEmpty) {
      todayTransactions = transactions
          .where(
            (element) => element.date.substring(0, 10) == todayStr,
          )
          .toList();
    }

    return todayTransactions;
  }

  // filter transactions that accuring this week
  List<FinancialTransaction> getThisWeekTransactions(
    List<FinancialTransaction> transactions,
  ) {
    final today = DateTime.now();
    final todayWeekDay = today.weekday;
    var weekTransactions = <FinancialTransaction>[];

    final firstDayOfWeek = today.subtract(
      Duration(days: todayWeekDay - 1),
    );

    final lastDayOfWeek = today.add(
      Duration(days: 7 - todayWeekDay),
    );

    final firstDayOfWeekStr = firstDayOfWeek.toString().substring(0, 10);
    final lastDayOfWeekStr = lastDayOfWeek.toString().substring(0, 10);

    if (transactions.isNotEmpty) {
      weekTransactions = transactions
          .where((element) =>
              element.date.compareTo(firstDayOfWeekStr) >= 0 &&
              element.date.compareTo(lastDayOfWeekStr) <= 0,)
          .toList();
    }

    print('weekTransactions: ${weekTransactions.length}');

    return weekTransactions;
  }

  // filter transactions that accuring this month
  List<FinancialTransaction> getThisMonthTransactions(
    List<FinancialTransaction> transactions,
  ) {
    final today = DateTime.now();
    final todayMonth = today.month;
    final todayYear = today.year;
    var monthTransactions = <FinancialTransaction>[];

    final firstDayOfMonth = DateTime(todayYear, todayMonth);
    final lastDayOfMonth = DateTime(todayYear, todayMonth + 1, 0);

    final firstDayOfMonthStr = firstDayOfMonth.toString().substring(0, 10);
    final lastDayOfMonthStr = lastDayOfMonth.toString().substring(0, 10);

    if (transactions.isNotEmpty) {
      monthTransactions = transactions
          .where((element) =>
              element.date.compareTo(firstDayOfMonthStr) >= 0 &&
              element.date.compareTo(lastDayOfMonthStr) <= 0,)
          .toList();
    }

    print('monthTransactions: ${monthTransactions.length}');

    return monthTransactions;
  }

  void _getAndCalculateTransactions(List<FinancialTransaction> transactions) {
    final todayTransactions = getTodayTransactions(transactions);
    final thisWeekTransactions = getThisWeekTransactions(transactions);
    final thisMonthTransactions = getThisMonthTransactions(transactions);

    final dayTotalAmount = todayTransactions.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    final weekTotalAmount = thisWeekTransactions.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    final monthTotalAmount = thisMonthTransactions.fold(
      0,
      (previousValue, element) => previousValue + element.amount,
    );

    emit(
      state.copyWith(
        dayTotalAmount: dayTotalAmount,
        weekTotalAmount: weekTotalAmount,
        monthTotalAmount: monthTotalAmount,
        dayTransactions: todayTransactions,
        weekTransactions: thisWeekTransactions,
        monthTransactions: thisMonthTransactions,
      ),
    );
  }

  void setSummaryFilterBy(SummaryFilterBy filterBy) {
    emit(
      state.copyWith(
        filterBy: filterBy,
      ),
    );
  }
}
