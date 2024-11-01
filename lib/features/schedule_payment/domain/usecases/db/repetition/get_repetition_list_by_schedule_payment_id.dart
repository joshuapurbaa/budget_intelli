import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetRepetitionListBySchedulePaymentId
    implements UseCase<List<Repetition>, String> {
  GetRepetitionListBySchedulePaymentId(this.repoDb);

  final RepetitionRepoDb repoDb;

  @override
  Future<Either<Failure, List<Repetition>>> call(String params) {
    return repoDb.getRepetitionListBySchedulePaymentId(params);
  }
}
