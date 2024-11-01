part of 'schedule_payment_db_bloc.dart';

final class SchedulePaymentDbState extends Equatable {
  const SchedulePaymentDbState({
    this.insertSchedulePaymentSuccess = false,
    this.insertRepetitionsSuccess = false,
    this.updateRepetitionSuccess = false,
    this.getSchedulePaymentSuccess = false,
    this.getRepetitionSuccess = false,
    this.updateSchedulePaymentSuccess = false,
    this.errorMessageSchedulePayment,
    this.errorMessageRepetition,
    this.schedulePayment,
    this.schedulePayments = const [],
    this.schedulePaymentId,
    this.repetitions = const [],
  });

  final bool insertSchedulePaymentSuccess;
  final bool insertRepetitionsSuccess;
  final bool updateRepetitionSuccess;
  final bool updateSchedulePaymentSuccess;
  final bool getSchedulePaymentSuccess;
  final bool getRepetitionSuccess;
  final String? errorMessageSchedulePayment;
  final String? errorMessageRepetition;
  final SchedulePayment? schedulePayment;
  final List<SchedulePayment> schedulePayments;
  final String? schedulePaymentId;
  final List<Repetition> repetitions;

  SchedulePaymentDbState copyWith({
    bool? insertSchedulePaymentSuccess,
    bool? insertRepetitionsSuccess,
    bool? updateRepetitionSuccess,
    bool? getSchedulePaymentSuccess,
    String? errorMessageSchedulePayment,
    String? errorMessageRepetition,
    SchedulePayment? schedulePayment,
    List<SchedulePayment>? schedulePayments,
    String? schedulePaymentId,
    bool? getRepetitionSuccess,
    List<Repetition>? repetitions,
    bool? updateSchedulePaymentSuccess,
  }) {
    return SchedulePaymentDbState(
      insertSchedulePaymentSuccess:
          insertSchedulePaymentSuccess ?? this.insertSchedulePaymentSuccess,
      insertRepetitionsSuccess:
          insertRepetitionsSuccess ?? this.insertRepetitionsSuccess,
      updateRepetitionSuccess:
          updateRepetitionSuccess ?? this.updateRepetitionSuccess,
      getSchedulePaymentSuccess:
          getSchedulePaymentSuccess ?? this.getSchedulePaymentSuccess,
      errorMessageSchedulePayment:
          errorMessageSchedulePayment ?? this.errorMessageSchedulePayment,
      schedulePayment: schedulePayment ?? this.schedulePayment,
      schedulePayments: schedulePayments ?? this.schedulePayments,
      schedulePaymentId: schedulePaymentId ?? this.schedulePaymentId,
      getRepetitionSuccess: getRepetitionSuccess ?? this.getRepetitionSuccess,
      errorMessageRepetition:
          errorMessageRepetition ?? this.errorMessageRepetition,
      repetitions: repetitions ?? this.repetitions,
      updateSchedulePaymentSuccess:
          updateSchedulePaymentSuccess ?? this.updateSchedulePaymentSuccess,
    );
  }

  @override
  List<Object?> get props => [
        schedulePayment,
        schedulePayments,
        repetitions,
        insertRepetitionsSuccess,
        insertSchedulePaymentSuccess,
        updateRepetitionSuccess,
        getSchedulePaymentSuccess,
        getRepetitionSuccess,
        updateSchedulePaymentSuccess,
      ];
}
