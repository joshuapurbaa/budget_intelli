import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertGoalToDb implements UseCase<Unit, GoalModel> {
  InsertGoalToDb(this.repository);
  final GoalRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GoalModel params) {
    return repository.insertGoal(params);
  }
}
