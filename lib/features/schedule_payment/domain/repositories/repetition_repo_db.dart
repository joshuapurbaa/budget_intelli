import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class RepetitionRepoDb {
  Future<Either<Failure, Unit>> insertRepetitionDb(Repetition repetition);
  Future<Either<Failure, Unit>> insertRepetitionsDb(
    List<Repetition> repetitions,
  );
  Future<Either<Failure, List<Repetition>>>
      getRepetitionListBySchedulePaymentId(String schedulePaymentId);
  Future<Either<Failure, Unit>> updateRepetitionDb(Repetition repetition);
  Future<Either<Failure, Unit>> deleteRepetitionDb(String id);
  Future<Either<Failure, Repetition?>> getRepetitionDbById(String id);
}
