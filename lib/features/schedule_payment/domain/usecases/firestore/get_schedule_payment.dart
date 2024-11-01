import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetSchedulePayment implements UseCase<SchedulePayment, String> {
  GetSchedulePayment(this.repository);
  final SchedulePaymentRepoFire repository;
  @override
  Future<Either<Failure, SchedulePayment>> call(String params) {
    return repository.getSchedulePayment(params);
  }
}
