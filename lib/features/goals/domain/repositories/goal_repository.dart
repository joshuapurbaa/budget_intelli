import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GoalRepository {
  Future<Either<Failure, GoalModel?>> getGoalById(String id);
  Future<Either<Failure, List<GoalModel>>> getGoals();
  Future<Either<Failure, Unit>> insertGoal(GoalModel goal);
  Future<Either<Failure, Unit>> deleteGoal(String id);
  Future<Either<Failure, Unit>> updateGoal(GoalModel goal);
}

class GoalRepositoryImpl implements GoalRepository {
  GoalRepositoryImpl(this.api);

  final GoalDatabaseApi api;
  @override
  Future<Either<Failure, Unit>> deleteGoal(String id) async {
    try {
      await api.deleteGoal(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, GoalModel?>> getGoalById(String id) async {
    try {
      final result = await api.getGoalById(id);
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<GoalModel>>> getGoals() async {
    try {
      final result = await api.getGoals();
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertGoal(GoalModel goal) async {
    try {
      await api.insertGoal(goal);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGoal(GoalModel goal) async {
    try {
      await api.updateGoal(goal);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
