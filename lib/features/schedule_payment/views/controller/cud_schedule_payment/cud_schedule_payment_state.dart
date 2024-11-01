part of 'cud_schedule_payment_bloc.dart';

@immutable
sealed class CudSchedulePaymentState {}

final class CudSchedulePaymentInitial extends CudSchedulePaymentState {}

final class CudSchedulePaymentLoading extends CudSchedulePaymentState {}

final class CudSchedulePaymentCreated extends CudSchedulePaymentState {
  CudSchedulePaymentCreated(this.id);
  final String id;
}

final class CudSchedulePaymentUpdated extends CudSchedulePaymentState {}

final class CudSchedulePaymentDeleted extends CudSchedulePaymentState {}

final class CudSchedulePaymentFailure extends CudSchedulePaymentState {
  CudSchedulePaymentFailure(this.message);
  final String message;
}
