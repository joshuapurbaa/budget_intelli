import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class RepetitionRepoDbImpl implements RepetitionRepoDb {
  RepetitionRepoDbImpl(this.api);

  final RepetitionDatabaseApi api;

  @override
  Future<Either<Failure, Unit>> deleteRepetitionDb(String id) async {
    try {
      await api.deleteRepetitionDb(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Repetition?>> getRepetitionDbById(String id) async {
    try {
      final result = await api.getRepetitionDbById(id);
      if (result != null) {
        return right(result);
      } else {
        return right(null);
      }
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Repetition>>>
      getRepetitionListBySchedulePaymentId(
    String schedulePaymentId,
  ) async {
    try {
      final result =
          await api.getRepetitionListBySchedulePaymentId(schedulePaymentId);
      return right(result);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertRepetitionDb(
    Repetition repetition,
  ) async {
    try {
      await api.insertRepetitionDb(repetition);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertRepetitionsDb(
    List<Repetition> repetitions,
  ) async {
    try {
      await api.insertRepetitionsDb(repetitions);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRepetitionDb(
    Repetition repetition,
  ) async {
    try {
      await api.updateRepetitionDb(repetition);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
