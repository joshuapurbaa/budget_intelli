import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/domain/repositories/schedule_payment_repo_fire.dart';
import 'package:fpdart/fpdart.dart';

class DeleteSchedulePayment implements UseCase<Unit, String> {
  DeleteSchedulePayment(this.repository);
  final SchedulePaymentRepoFire repository;

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return repository.deleteSchedulePayment(params);
  }
}
