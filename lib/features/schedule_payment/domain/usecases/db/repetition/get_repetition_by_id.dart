import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetRepetitionById implements UseCase<Repetition?, String> {
  GetRepetitionById(this.repoDb);

  final RepetitionRepoDb repoDb;
  @override
  Future<Either<Failure, Repetition?>> call(String params) {
    return repoDb.getRepetitionDbById(params);
  }
}
