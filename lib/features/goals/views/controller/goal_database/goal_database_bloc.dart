import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'goal_database_event.dart';
part 'goal_database_state.dart';

class GoalDatabaseBloc extends Bloc<GoalDatabaseEvent, GoalDatabaseState> {
  GoalDatabaseBloc({
    required InsertGoalToDb insertGoalToDb,
    required UpdateGoalFromDb updateGoalFromDb,
    required GetGoalFromDbById getGoalFromDbById,
    required GetGoalsFromDb getGoalsFromDb,
    required DeleteGoalFromDb deleteGoalFromDb,
  })  : _insertGoalToDb = insertGoalToDb,
        _updateGoalFromDb = updateGoalFromDb,
        _getGoalFromDbById = getGoalFromDbById,
        _getGoalsFromDb = getGoalsFromDb,
        _deleteGoalFromDb = deleteGoalFromDb,
        super(const GoalDatabaseState()) {
    on<InsertGoalToDbEvent>(_onInsertGoalToDbEvent);
    on<UpdateGoalFromDBEvent>(_onUpdateGoalFromDBEvent);
    on<DeleteGoalByIdFromDbEvent>(_onDeleteGoalByIdFromDbEvent);
    on<GetGoalsFromDbEvent>(_onGetGoalsFromDbEvent);
    on<GetGoalFromDbByIdEvent>(_onGetGoalFromDbByIdEvent);
    on<ResetGoalStateEvent>(_onResetGoalStateEvent);
  }

  final InsertGoalToDb _insertGoalToDb;
  final UpdateGoalFromDb _updateGoalFromDb;
  final GetGoalFromDbById _getGoalFromDbById;
  final GetGoalsFromDb _getGoalsFromDb;
  final DeleteGoalFromDb _deleteGoalFromDb;

  Future<void> _onResetGoalStateEvent(
    ResetGoalStateEvent event,
    Emitter<GoalDatabaseState> emit,
  ) async {
    emit(
      state.copyWith(
        insertGoalSuccess: false,
        updateGoalSuccess: false,
        deleteGoalSuccess: false,
      ),
    );
  }

  Future<void> _onInsertGoalToDbEvent(
    InsertGoalToDbEvent event,
    Emitter<GoalDatabaseState> emit,
  ) async {
    final result = await _insertGoalToDb(event.goal);

    result.fold(
      (fail) => emit(
        state.copyWith(
          insertGoalSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertGoalSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateGoalFromDBEvent(
    UpdateGoalFromDBEvent event,
    Emitter<GoalDatabaseState> emit,
  ) async {
    final result = await _updateGoalFromDb(event.goal);

    result.fold(
      (fail) => emit(
        state.copyWith(
          updateGoalSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateGoalSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onDeleteGoalByIdFromDbEvent(
    DeleteGoalByIdFromDbEvent event,
    Emitter<GoalDatabaseState> emit,
  ) async {
    final result = await _deleteGoalFromDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          deleteGoalSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteGoalSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onGetGoalsFromDbEvent(
    GetGoalsFromDbEvent event,
    Emitter<GoalDatabaseState> emit,
  ) async {
    final result = await _getGoalsFromDb(NoParams());

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (goals) => emit(
        state.copyWith(
          goals: goals,
        ),
      ),
    );
  }

  Future<void> _onGetGoalFromDbByIdEvent(
    GetGoalFromDbByIdEvent event,
    Emitter<GoalDatabaseState> emit,
  ) async {
    final result = await _getGoalFromDbById(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (goal) => emit(
        state.copyWith(
          goal: goal,
        ),
      ),
    );
  }
}
