import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertRepetitionsToDb implements UseCase<Unit, List<Repetition>> {
  InsertRepetitionsToDb(this.repoDb);

  final RepetitionRepoDb repoDb;

  @override
  Future<Either<Failure, Unit>> call(List<Repetition> params) {
    return repoDb.insertRepetitionsDb(params);
  }
}
