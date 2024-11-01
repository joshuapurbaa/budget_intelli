import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class SchedulePaymentRepositoryImplDb implements SchedulePaymentRepositoryDb {
  SchedulePaymentRepositoryImplDb(this.api);

  final SchedulePaymentDatabaseApi api;
  @override
  Future<Either<Failure, Unit>> insertSchedulePaymentDb(
    SchedulePayment params,
  ) async {
    try {
      await api.insertSchedulePaymentApi(params);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedulePaymentDbById(
    String id,
  ) async {
    try {
      await api.deleteSchedulePaymentByIdApi(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, SchedulePayment?>> getSchedulePaymentDbById(
    String id,
  ) async {
    try {
      final result = await api.getSchedulePaymentByIdApi(id);
      if (result != null) {
        return right(result);
      } else {
        return left(Failure('No data'));
      }
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SchedulePayment>>> getSchedulePaymentsDb() async {
    try {
      final result = await api.getSchedulePaymentsApi();

      return right(result);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSchedulePaymentDb(
    SchedulePayment params,
  ) async {
    try {
      await api.updateSchedulePayment(params);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
