import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetSchedulePaymentsDb
    implements UseCase<List<SchedulePayment>, NoParams> {
  GetSchedulePaymentsDb(this.repository);
  final SchedulePaymentRepositoryDb repository;

  @override
  Future<Either<Failure, List<SchedulePayment>>> call(
    NoParams params,
  ) {
    return repository.getSchedulePaymentsDb();
  }
}
