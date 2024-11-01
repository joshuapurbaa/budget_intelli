import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cud_schedule_payment_event.dart';
part 'cud_schedule_payment_state.dart';

class CudSchedulePaymentBloc
    extends Bloc<CudSchedulePaymentEvent, CudSchedulePaymentState> {
  CudSchedulePaymentBloc({
    required UpdateSchedulePayment updateSchedulePayment,
    required CreateSchedulePaymentFire createSchedulePayment,
    required DeleteSchedulePayment deleteSchedulePayment,
  })  : _updateSchedulePayment = updateSchedulePayment,
        _createSchedulePayment = createSchedulePayment,
        _deleteSchedulePayment = deleteSchedulePayment,
        super(CudSchedulePaymentInitial()) {
    on<CudSchedulePaymentEvent>((event, emit) => CudSchedulePaymentLoading());
    on<UpdateSchedulePaymentEvent>(_onUpdateSchedulePaymentEvent);
    on<CreateSchedulePaymentEvent>(_onCreateSchedulePaymentEvent);
    on<DeleteSchedulePaymentEvent>(_onDeleteSchedulePaymentEvent);
    on<ResetCudSchedulePaymentEvent>(
      (event, emit) => emit(CudSchedulePaymentInitial()),
    );
  }

  final UpdateSchedulePayment _updateSchedulePayment;
  final CreateSchedulePaymentFire _createSchedulePayment;
  final DeleteSchedulePayment _deleteSchedulePayment;

  Future<void> _onUpdateSchedulePaymentEvent(
    UpdateSchedulePaymentEvent event,
    Emitter<CudSchedulePaymentState> emit,
  ) async {
    final result = await _updateSchedulePayment.call(
      event.schedulePayment,
    );

    result.fold(
      (failure) => emit(CudSchedulePaymentFailure(failure.message)),
      (schedulePayment) => emit(CudSchedulePaymentUpdated()),
    );
  }

  Future<void> _onCreateSchedulePaymentEvent(
    CreateSchedulePaymentEvent event,
    Emitter<CudSchedulePaymentState> emit,
  ) async {
    emit(CudSchedulePaymentLoading());
    final result = await _createSchedulePayment(
      event.schedulePayment,
    );

    result.fold(
      (failure) => emit(CudSchedulePaymentFailure(failure.message)),
      (id) {
        emit(CudSchedulePaymentCreated(id));
      },
    );
  }

  Future<void> _onDeleteSchedulePaymentEvent(
    DeleteSchedulePaymentEvent event,
    Emitter<CudSchedulePaymentState> emit,
  ) async {
    final result = await _deleteSchedulePayment.call(event.id);

    result.fold(
      (failure) => emit(CudSchedulePaymentFailure(failure.message)),
      (success) => emit(CudSchedulePaymentDeleted()),
    );
  }
}
