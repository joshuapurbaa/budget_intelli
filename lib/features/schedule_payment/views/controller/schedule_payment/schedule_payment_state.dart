part of 'schedule_payment_bloc.dart';

@immutable
sealed class SchedulePaymentState {}

final class SchedulePaymentInitial extends SchedulePaymentState {}

final class SchedulePaymentLoading extends SchedulePaymentState {}

final class GetSchedulePaymentsSuccess extends SchedulePaymentState {
  GetSchedulePaymentsSuccess(this.schedulePayments);
  final List<SchedulePayment> schedulePayments;
}

final class SchedulePaymentFailure extends SchedulePaymentState {
  SchedulePaymentFailure(this.message);
  final String message;
}
