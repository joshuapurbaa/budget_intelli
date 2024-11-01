import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_schedule_payment_state.dart';

class GetSchedulePaymentCubit extends Cubit<GetSchedulePaymentState> {
  GetSchedulePaymentCubit({
    required GetSchedulePayment getSchedulePayment,
  })  : _getSchedulePayment = getSchedulePayment,
        super(GetSchedulePaymentInitial());

  final GetSchedulePayment _getSchedulePayment;

  // set to loading state
  void setToLoading() {
    emit(GetSchedulePaymentByIdLoading());
  }

  Future<void> getSchedulePaymentById(String id) async {
    emit(GetSchedulePaymentByIdLoading());
    final result = await _getSchedulePayment.call(id);

    result.fold(
      (failure) => emit(GetSchedulePaymentByIdFailure(failure.message)),
      (schedulePayment) => emit(GetSchedulePaymentIdSuccess(schedulePayment)),
    );
  }
}
