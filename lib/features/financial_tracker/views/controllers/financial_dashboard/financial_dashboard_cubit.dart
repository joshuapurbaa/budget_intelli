import 'package:budget_intelli/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'financial_dashboard_state.dart';

class FinancialDashboardCubit extends Cubit<FinancialDashboardState> {
  FinancialDashboardCubit() : super(FinancialDashboardState());

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
}
