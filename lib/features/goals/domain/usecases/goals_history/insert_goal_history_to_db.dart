import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertGoalHistoryToDb implements UseCase<Unit, GoalHistoryModel> {
  InsertGoalHistoryToDb(this.repository);
  final GoalHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(GoalHistoryModel params) {
    return repository.insertGoalHistory(params);
  }
}
