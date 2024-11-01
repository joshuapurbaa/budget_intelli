import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetSchedulePaymentDbById implements UseCase<SchedulePayment?, String> {
  GetSchedulePaymentDbById(this.repository);
  final SchedulePaymentRepositoryDb repository;
  @override
  Future<Either<Failure, SchedulePayment?>> call(String id) {
    return repository.getSchedulePaymentDbById(id);
  }
}
