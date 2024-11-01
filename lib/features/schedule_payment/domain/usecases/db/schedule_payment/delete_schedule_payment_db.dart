import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteSchedulePaymentDbById implements UseCase<Unit, String> {
  DeleteSchedulePaymentDbById(this.repository);
  final SchedulePaymentRepositoryDb repository;

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return repository.deleteSchedulePaymentDbById(id);
  }
}
