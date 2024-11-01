import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteGoalHistoryFromDb implements UseCase<Unit, String> {
  DeleteGoalHistoryFromDb(this.repository);

  final GoalHistoryRepository repository;
  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteGoalHistory(params);
  }
}
