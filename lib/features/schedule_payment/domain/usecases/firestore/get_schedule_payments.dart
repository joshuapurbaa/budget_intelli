import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetSchedulePayments
    implements UseCase<List<SchedulePayment>, GetSchedulePaymentsParams> {
  GetSchedulePayments(this.repository);
  final SchedulePaymentRepoFire repository;

  @override
  Future<Either<Failure, List<SchedulePayment>>> call(
    GetSchedulePaymentsParams params,
  ) {
    return repository.getSchedulePayments(params);
  }
}
