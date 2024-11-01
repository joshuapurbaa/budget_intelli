import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GoalHistoryDatabaseApi {
  Future<GoalHistoryModel?> getGoalHistoryById(String id);
  Future<List<GoalHistoryModel>> getGoalsHistory();
  Future<List<GoalHistoryModel>> getGoalsHistoryByGoalId(String goalId);
  Future<Unit> insertGoalHistory(GoalHistoryModel goal);
  Future<Unit> deleteGoalHistory(String id);
  Future<Unit> updateGoalHistory(GoalHistoryModel goal);
}

class GoalHistoryDatabaseApiImpl implements GoalHistoryDatabaseApi {
  GoalHistoryDatabaseApiImpl(this.goalDatabase);

  final GoalDatabase goalDatabase;
  @override
  Future<Unit> deleteGoalHistory(String id) async {
    try {
      await goalDatabase.database;
      await goalDatabase.deleteGoalHistory(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<GoalHistoryModel?> getGoalHistoryById(String id) async {
    try {
      await goalDatabase.database;
      final result = await goalDatabase.getGoalHistoryById(id);
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<GoalHistoryModel>> getGoalsHistory() async {
    try {
      await goalDatabase.database;
      final result = await goalDatabase.getAllGoalsHistory();
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertGoalHistory(GoalHistoryModel goal) async {
    try {
      await goalDatabase.database;
      await goalDatabase.insertGoalHistory(goal);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateGoalHistory(GoalHistoryModel goal) async {
    try {
      await goalDatabase.database;
      await goalDatabase.updateGoalHistory(goal);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<GoalHistoryModel>> getGoalsHistoryByGoalId(
    String goalId,
  ) async {
    try {
      await goalDatabase.database;
      final result = await goalDatabase.getGoalsHistoryByGoalId(goalId);
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
