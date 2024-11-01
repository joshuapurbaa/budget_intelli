import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GoalHistoryRepository {
  Future<Either<Failure, GoalHistoryModel?>> getGoalHistoryById(String id);
  Future<Either<Failure, List<GoalHistoryModel>>> getGoalsHistory();
  Future<Either<Failure, List<GoalHistoryModel>>> getGoalsHistoryByGoalId(
    String goalId,
  );
  Future<Either<Failure, Unit>> insertGoalHistory(GoalHistoryModel goal);
  Future<Either<Failure, Unit>> deleteGoalHistory(String id);
  Future<Either<Failure, Unit>> updateGoalHistory(GoalHistoryModel goal);
}

class GoalHistoryRepositoryImpl implements GoalHistoryRepository {
  GoalHistoryRepositoryImpl(this.api);

  final GoalHistoryDatabaseApi api;
  @override
  Future<Either<Failure, Unit>> deleteGoalHistory(String id) async {
    try {
      await api.deleteGoalHistory(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, GoalHistoryModel?>> getGoalHistoryById(
    String id,
  ) async {
    try {
      final result = await api.getGoalHistoryById(id);
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<GoalHistoryModel>>> getGoalsHistory() async {
    try {
      final result = await api.getGoalsHistory();
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertGoalHistory(GoalHistoryModel goal) async {
    try {
      await api.insertGoalHistory(goal);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGoalHistory(GoalHistoryModel goal) async {
    try {
      await api.updateGoalHistory(goal);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<GoalHistoryModel>>> getGoalsHistoryByGoalId(
    String goalId,
  ) async {
    try {
      final result = await api.getGoalsHistoryByGoalId(goalId);
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
