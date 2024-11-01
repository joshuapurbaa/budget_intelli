import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SchedulePaymentRepoFire {
  Future<Either<Failure, List<SchedulePayment>>> getSchedulePayments(
    GetSchedulePaymentsParams params,
  );
  Future<Either<Failure, SchedulePayment>> getSchedulePayment(String id);
  Future<Either<Failure, String>> createSchedulePaymentFire(
    SchedulePayment params,
  );
  Future<Either<Failure, Unit>> updateSchedulePayment(SchedulePayment params);
  Future<Either<Failure, Unit>> deleteSchedulePayment(String id);
}
