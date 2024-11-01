import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'schedule_payment_event.dart';
part 'schedule_payment_state.dart';

class SchedulePaymentBloc
    extends Bloc<SchedulePaymentEvent, SchedulePaymentState> {
  SchedulePaymentBloc({
    required GetSchedulePayments getSchedulePayments,
  })  : _getSchedulePayments = getSchedulePayments,
        super(SchedulePaymentInitial()) {
    on<SchedulePaymentEvent>((event, emit) => SchedulePaymentLoading());
    on<GetSchedulePaymentsEvent>(_onGetSchedulePaymentsEvent);
  }

  final GetSchedulePayments _getSchedulePayments;

  Future<void> _onGetSchedulePaymentsEvent(
    GetSchedulePaymentsEvent event,
    Emitter<SchedulePaymentState> emit,
  ) async {
    final result = await _getSchedulePayments.call(
      GetSchedulePaymentsParams(
        limit: event.limit,
        offset: event.offset,
        search: event.search,
        orderBy: event.orderBy,
        isDescending: event.isDescending,
        lastDocument: event.lastDocument,
        filterBy: event.filterBy,
      ),
    );

    result.fold(
      (failure) => emit(SchedulePaymentFailure(failure.message)),
      (schedulePayments) => emit(GetSchedulePaymentsSuccess(schedulePayments)),
    );
  }
}
