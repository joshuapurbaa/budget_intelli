import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class SchedulePaymentRepoImplFire implements SchedulePaymentRepoFire {
  SchedulePaymentRepoImplFire({
    required this.remoteDataSource,
    required this.connectionChecker,
  });
  final SchedulePaymentRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  @override
  Future<Either<Failure, List<SchedulePayment>>> getSchedulePayments(
    GetSchedulePaymentsParams params,
  ) async {
    try {
      final schedulePayments = await remoteDataSource.getSchedulePayments(
        params,
      );
      return right(schedulePayments);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, SchedulePayment>> getSchedulePayment(String id) async {
    try {
      final schedulePayment = await remoteDataSource.getSchedulePayment(id);
      return right(schedulePayment);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> createSchedulePaymentFire(
    SchedulePayment params,
  ) async {
    try {
      if (await connectionChecker.isConnected) {
        final id = await remoteDataSource.createSchedulePaymentFire(params);
        return right(id);
      }
      return left(Failure(ErrorMessages.noInternetConnection));
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSchedulePayment(
    SchedulePayment params,
  ) async {
    try {
      if (await connectionChecker.isConnected) {
        await remoteDataSource.updateSchedulePayment(
          params,
        );
        return right(unit);
      }
      return left(Failure(ErrorMessages.noInternetConnection));
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedulePayment(String id) async {
    try {
      if (await connectionChecker.isConnected) {
        await remoteDataSource.deleteSchedulePayment(id);
        return right(unit);
      }
      return left(Failure(ErrorMessages.noInternetConnection));
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }
}
