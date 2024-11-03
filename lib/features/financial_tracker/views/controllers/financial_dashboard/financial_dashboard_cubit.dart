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
}
