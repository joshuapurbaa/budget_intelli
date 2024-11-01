part of 'cud_schedule_payment_bloc.dart';

@immutable
sealed class CudSchedulePaymentEvent {}

class CreateSchedulePaymentEvent extends CudSchedulePaymentEvent {
  CreateSchedulePaymentEvent({
    required this.schedulePayment,
  });

  final SchedulePayment schedulePayment;
}

class UpdateSchedulePaymentEvent extends CudSchedulePaymentEvent {
  UpdateSchedulePaymentEvent({
    required this.schedulePayment,
  });

  final SchedulePayment schedulePayment;
}

class DeleteSchedulePaymentEvent extends CudSchedulePaymentEvent {
  DeleteSchedulePaymentEvent(this.id);

  final String id;
}

class ResetCudSchedulePaymentEvent extends CudSchedulePaymentEvent {}
