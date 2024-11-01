part of 'goal_database_bloc.dart';

final class GoalDatabaseState extends Equatable {
  const GoalDatabaseState({
    this.insertGoalSuccess = false,
    this.updateGoalSuccess = false,
    this.deleteGoalSuccess = false,
    this.errorMessage,
    this.goal,
    this.goals = const [],
  });

  final bool insertGoalSuccess;
  final bool updateGoalSuccess;
  final bool deleteGoalSuccess;
  final String? errorMessage;
  final GoalModel? goal;
  final List<GoalModel> goals;

  GoalDatabaseState copyWith({
    bool? insertGoalSuccess,
    bool? updateGoalSuccess,
    bool? deleteGoalSuccess,
    String? errorMessage,
    GoalModel? goal,
    List<GoalModel>? goals,
  }) {
    return GoalDatabaseState(
      insertGoalSuccess: insertGoalSuccess ?? this.insertGoalSuccess,
      updateGoalSuccess: updateGoalSuccess ?? this.updateGoalSuccess,
      deleteGoalSuccess: deleteGoalSuccess ?? this.deleteGoalSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      goal: goal ?? this.goal,
      goals: goals ?? this.goals,
    );
  }

  @override
  List<Object?> get props => [
        insertGoalSuccess,
        updateGoalSuccess,
        deleteGoalSuccess,
        errorMessage,
        goal,
        goals,
      ];
}
