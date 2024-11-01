import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateGoalHistoryFromDb implements UseCase<Unit, GoalHistoryModel> {
  UpdateGoalHistoryFromDb(this.repository);

  final GoalHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GoalHistoryModel params) {
    return repository.updateGoalHistory(params);
  }
}
