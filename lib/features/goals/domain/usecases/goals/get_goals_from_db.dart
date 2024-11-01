import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGoalsFromDb implements UseCase<List<GoalModel>, NoParams> {
  GetGoalsFromDb(this.repository);
  final GoalRepository repository;

  @override
  Future<Either<Failure, List<GoalModel>>> call(NoParams params) {
    return repository.getGoals();
  }
}
