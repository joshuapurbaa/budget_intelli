import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGoalHistoryFromDbByGoalId
    implements UseCase<List<GoalHistoryModel>, String> {
  GetGoalHistoryFromDbByGoalId(this.repository);

  final GoalHistoryRepository repository;

  @override
  Future<Either<Failure, List<GoalHistoryModel>>> call(String params) {
    return repository.getGoalsHistoryByGoalId(params);
  }
}
