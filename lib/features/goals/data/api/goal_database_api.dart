import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GoalDatabaseApi {
  Future<GoalModel?> getGoalById(String id);
  Future<List<GoalModel>> getGoals();
  Future<Unit> insertGoal(GoalModel goal);
  Future<Unit> deleteGoal(String id);
  Future<Unit> updateGoal(GoalModel goal);
}

class GoalDatabaseApiImpl implements GoalDatabaseApi {
  GoalDatabaseApiImpl(this.goalDatabase);

  final GoalDatabase goalDatabase;
  @override
  Future<Unit> deleteGoal(String id) async {
    try {
      await goalDatabase.database;
      await goalDatabase.deleteGoal(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<GoalModel?> getGoalById(String id) async {
    try {
      await goalDatabase.database;
      final result = await goalDatabase.getGoalById(id);
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<GoalModel>> getGoals() async {
    try {
      await goalDatabase.database;
      final result = await goalDatabase.getAllGoals();
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertGoal(GoalModel goal) async {
    try {
      await goalDatabase.database;
      await goalDatabase.insertGoal(goal);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateGoal(GoalModel goal) async {
    try {
      await goalDatabase.database;
      await goalDatabase.updateGoal(goal);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
