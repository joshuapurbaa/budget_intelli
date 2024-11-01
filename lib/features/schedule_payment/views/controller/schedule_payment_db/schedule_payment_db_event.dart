part of 'schedule_payment_db_bloc.dart';

sealed class SchedulePaymentDbEvent extends Equatable {
  const SchedulePaymentDbEvent();

  @override
  List<Object> get props => [];
}

class InsertSchedulePaymentToDb extends SchedulePaymentDbEvent {
  const InsertSchedulePaymentToDb({required this.schedulePayment});

  final SchedulePayment schedulePayment;
}

class GetSchedulePaymentByIdFromDb extends SchedulePaymentDbEvent {
  const GetSchedulePaymentByIdFromDb({required this.id});

  final String id;
}

class GetSchedulePaymentsFromDb extends SchedulePaymentDbEvent {}

class ResetStatePaymentDbBloc extends SchedulePaymentDbEvent {}

class GetRepetitionListBySchedulePaymentIdEvent extends SchedulePaymentDbEvent {
  GetRepetitionListBySchedulePaymentIdEvent(
    this.schedulePaymentId,
  );

  final String schedulePaymentId;
}

final class InsertRepetitionsEvent extends SchedulePaymentDbEvent {
  const InsertRepetitionsEvent(this.repetitions);

  final List<Repetition> repetitions;
}

final class UpdateRepetitionByIdEvent extends SchedulePaymentDbEvent {
  const UpdateRepetitionByIdEvent(this.repetition);

  final Repetition repetition;
}

final class UpdateSchedulePaymentDbEvent extends SchedulePaymentDbEvent {
  const UpdateSchedulePaymentDbEvent(this.scheduluPayment);

  final SchedulePayment scheduluPayment;
}
