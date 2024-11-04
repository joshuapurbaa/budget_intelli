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
          state.copyWith(transactions: []),
        ),
        (transactions) => emit(
          state.copyWith(
            transactions: transactions,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(transactions: []),
      );
    }
  }

  // filter transactions that accuring today
  List<FinancialTransaction> getTodayTransactions() {
    final today = DateTime.now();
    final todayStr = today.toString().substring(0, 10);

    return state.transactions
        .where((element) => element.date == todayStr)
        .toList();
  }

  // filter transactions that accuring this week
  List<FinancialTransaction> getThisWeekTransactions() {
    final today = DateTime.now();
    final todayWeekDay = today.weekday;

    final firstDayOfWeek = today.subtract(
      Duration(days: todayWeekDay - 1),
    );

    final lastDayOfWeek = today.add(
      Duration(days: 7 - todayWeekDay),
    );

    final firstDayOfWeekStr = firstDayOfWeek.toString().substring(0, 10);
    final lastDayOfWeekStr = lastDayOfWeek.toString().substring(0, 10);

    return state.transactions
        .where((element) =>
            element.date.compareTo(firstDayOfWeekStr) >= 0 &&
            element.date.compareTo(lastDayOfWeekStr) <= 0)
        .toList();
  }

  // filter transactions that accuring this month
  List<FinancialTransaction> getThisMonthTransactions() {
    final today = DateTime.now();
    final todayMonth = today.month;
    final todayYear = today.year;

    final firstDayOfMonth = DateTime(todayYear, todayMonth, 1);
    final lastDayOfMonth = DateTime(todayYear, todayMonth + 1, 0);

    final firstDayOfMonthStr = firstDayOfMonth.toString().substring(0, 10);
    final lastDayOfMonthStr = lastDayOfMonth.toString().substring(0, 10);

    return state.transactions
        .where((element) =>
            element.date.compareTo(firstDayOfMonthStr) >= 0 &&
            element.date.compareTo(lastDayOfMonthStr) <= 0)
        .toList();
  }
}
