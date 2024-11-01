part of 'get_schedule_payment_cubit.dart';

@immutable
sealed class GetSchedulePaymentState {}

final class GetSchedulePaymentInitial extends GetSchedulePaymentState {}

final class GetSchedulePaymentByIdLoading extends GetSchedulePaymentState {}

final class GetSchedulePaymentIdSuccess extends GetSchedulePaymentState {
  GetSchedulePaymentIdSuccess(this.schedulePayment);
  final SchedulePayment schedulePayment;
}

final class GetSchedulePaymentByIdFailure extends GetSchedulePaymentState {
  GetSchedulePaymentByIdFailure(this.message);
  final String message;
}
