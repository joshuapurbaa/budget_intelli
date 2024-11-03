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

  void selectMonth({required String month}) {
    emit(state.copyWith(selectedMonth: month));
  }

  void toggleIncome({required bool isIncome}) {
    emit(
      state.copyWith(
        isIncome: isIncome,
      ),
    );
  }

  Future<void> getAllFinancialTransactionByMonthAndYear() async {
    final monthNumber =
        AppStrings.monthListFullEn.indexOf(state.selectedMonth) + 1;
    final monthString =
        monthNumber < 10 ? '0$monthNumber' : monthNumber.toString();
    final result = await _getAllFinancialTransactionByMonthAndYearDb(
      MonthYearParams(
        month: monthString,
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
  }
}
