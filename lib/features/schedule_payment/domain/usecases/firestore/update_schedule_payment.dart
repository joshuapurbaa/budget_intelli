import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateSchedulePayment implements UseCase<Unit, SchedulePayment> {
  UpdateSchedulePayment(this.repository);
  final SchedulePaymentRepoFire repository;
  @override
  Future<Either<Failure, Unit>> call(SchedulePayment params) {
    return repository.updateSchedulePayment(params);
  }
}
