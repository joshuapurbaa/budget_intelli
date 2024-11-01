import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SchedulePaymentRepositoryDb {
  Future<Either<Failure, Unit>> insertSchedulePaymentDb(
    SchedulePayment params,
  );
  Future<Either<Failure, List<SchedulePayment>>> getSchedulePaymentsDb();
  Future<Either<Failure, SchedulePayment?>> getSchedulePaymentDbById(
    String id,
  );
  Future<Either<Failure, Unit>> updateSchedulePaymentDb(
    SchedulePayment params,
  );
  Future<Either<Failure, Unit>> deleteSchedulePaymentDbById(
    String id,
  );
}
