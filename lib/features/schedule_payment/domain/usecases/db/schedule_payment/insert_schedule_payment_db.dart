import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertSchedulePaymentDb implements UseCase<Unit, SchedulePayment> {
  InsertSchedulePaymentDb(this.repository);

  final SchedulePaymentRepositoryDb repository;

  @override
  Future<Either<Failure, Unit>> call(SchedulePayment params) {
    return repository.insertSchedulePaymentDb(params);
  }
}
