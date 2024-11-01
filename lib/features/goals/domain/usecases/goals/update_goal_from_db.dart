import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateGoalFromDb implements UseCase<Unit, GoalModel> {
  UpdateGoalFromDb(this.repository);

  final GoalRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GoalModel params) {
    return repository.updateGoal(params);
  }
}
