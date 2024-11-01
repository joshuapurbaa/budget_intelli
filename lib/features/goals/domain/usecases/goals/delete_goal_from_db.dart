import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteGoalFromDb implements UseCase<Unit, String> {
  DeleteGoalFromDb(this.repository);

  final GoalRepository repository;
  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteGoal(params);
  }
}
