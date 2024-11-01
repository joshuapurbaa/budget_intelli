import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertRepetitionToDb implements UseCase<Unit, Repetition> {
  InsertRepetitionToDb(this.repoDb);

  final RepetitionRepoDb repoDb;

  @override
  Future<Either<Failure, Unit>> call(Repetition params) {
    return repoDb.insertRepetitionDb(params);
  }
}
