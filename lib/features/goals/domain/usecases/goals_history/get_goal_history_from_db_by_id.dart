import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGoalHistoryFromDbById implements UseCase<GoalHistoryModel?, String> {
  GetGoalHistoryFromDbById(this.repository);

  final GoalHistoryRepository repository;

  @override
  Future<Either<Failure, GoalHistoryModel?>> call(String params) {
    return repository.getGoalHistoryById(params);
  }
}
