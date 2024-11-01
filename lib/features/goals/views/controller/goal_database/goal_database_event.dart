part of 'goal_database_bloc.dart';

sealed class GoalDatabaseEvent extends Equatable {
  const GoalDatabaseEvent();

  @override
  List<Object> get props => [];
}

final class InsertGoalToDbEvent extends GoalDatabaseEvent {
  const InsertGoalToDbEvent(this.goal);

  final GoalModel goal;
}

final class UpdateGoalFromDBEvent extends GoalDatabaseEvent {
  const UpdateGoalFromDBEvent(this.goal);

  final GoalModel goal;
}

final class DeleteGoalByIdFromDbEvent extends GoalDatabaseEvent {
  const DeleteGoalByIdFromDbEvent(this.id);

  final String id;
}

final class GetGoalsFromDbEvent extends GoalDatabaseEvent {}

final class GetGoalFromDbByIdEvent extends GoalDatabaseEvent {
  const GetGoalFromDbByIdEvent(this.id);

  final String id;
}

final class ResetGoalStateEvent extends GoalDatabaseEvent {}
