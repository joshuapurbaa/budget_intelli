import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/domain/repositories/schedule_payment_repo_fire.dart';
import 'package:budget_intelli/features/schedule_payment/models/schedule_payment.dart';
import 'package:fpdart/fpdart.dart';

class CreateSchedulePaymentFire implements UseCase<String, SchedulePayment> {
  CreateSchedulePaymentFire(this.repository);

  final SchedulePaymentRepoFire repository;

  @override
  Future<Either<Failure, String>> call(SchedulePayment params) {
    return repository.createSchedulePaymentFire(params);
  }
}
