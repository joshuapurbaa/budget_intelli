import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'financial_category_history_event.dart';
part 'financial_category_history_state.dart';

class FinancialCategoryHistoryBloc
    extends Bloc<FinancialCategoryHistoryEvent, FinancialCategoryHistoryState> {
  FinancialCategoryHistoryBloc({
    required InsertFinancialCategoryHistoryDb insertFinancialCategoryHistoryDb,
    required UpdateFinancialCategoryHistoryDb updateFinancialCategoryHistoryDb,
    required DeleteFinancialCategoryHistoryDb deleteFinancialCategoryHistoryDb,
    required GetFinancialCategoryHistoryDb getFinancialCategoryHistoryDb,
    required GetFinancialCategoryHistoriesDb getFinancialCategoryHistoriesDb,
  })  : _insertFinancialCategoryHistoryDb = insertFinancialCategoryHistoryDb,
        _updateFinancialCategoryHistoryDb = updateFinancialCategoryHistoryDb,
        _deleteFinancialCategoryHistoryDb = deleteFinancialCategoryHistoryDb,
        _getFinancialCategoryHistoryDb = getFinancialCategoryHistoryDb,
        _getFinancialCategoryHistoriesDb = getFinancialCategoryHistoriesDb,
        super(const FinancialCategoryHistoryState()) {
    on<InsertFinancialCategoryHistoryEvent>(
        _onInsertFinancialCategoryHistoryEvent,);
    on<UpdateFinancialCategoryHistoryEvent>(
        _onUpdateFinancialCategoryHistoryEvent,);
    on<DeleteFinancialCategoryHistoryEvent>(
        _onDeleteFinancialCategoryHistoryEvent,);
    on<GetFinancialCategoryHistoryEvent>(_onGetFinancialCategoryHistoryEvent);
    on<GetFinancialCategoryHistoriesEvent>(
        _onGetFinancialCategoryHistoriesEvent,);
    on<ResetFinancialCategoryHistoryStateEvent>(
        _onResetFinancialCategoryHistoryStateEvent,);
  }

  final InsertFinancialCategoryHistoryDb _insertFinancialCategoryHistoryDb;
  final UpdateFinancialCategoryHistoryDb _updateFinancialCategoryHistoryDb;
  final DeleteFinancialCategoryHistoryDb _deleteFinancialCategoryHistoryDb;
  final GetFinancialCategoryHistoryDb _getFinancialCategoryHistoryDb;
  final GetFinancialCategoryHistoriesDb _getFinancialCategoryHistoriesDb;

  Future<void> _onInsertFinancialCategoryHistoryEvent(
    InsertFinancialCategoryHistoryEvent event,
    Emitter<FinancialCategoryHistoryState> emit,
  ) async {
    final result =
        await _insertFinancialCategoryHistoryDb(event.financialCategoryHistory);

    result.fold(
      (fail) => emit(
        state.copyWith(
          insertSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateFinancialCategoryHistoryEvent(
    UpdateFinancialCategoryHistoryEvent event,
    Emitter<FinancialCategoryHistoryState> emit,
  ) async {
    final result =
        await _updateFinancialCategoryHistoryDb(event.financialCategoryHistory);

    result.fold(
      (fail) => emit(
        state.copyWith(
          updateSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onDeleteFinancialCategoryHistoryEvent(
    DeleteFinancialCategoryHistoryEvent event,
    Emitter<FinancialCategoryHistoryState> emit,
  ) async {
    final result = await _deleteFinancialCategoryHistoryDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          deleteSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onGetFinancialCategoryHistoryEvent(
    GetFinancialCategoryHistoryEvent event,
    Emitter<FinancialCategoryHistoryState> emit,
  ) async {
    final result = await _getFinancialCategoryHistoryDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (financialCategoryHistory) => emit(
        state.copyWith(
          financialCategoryHistory: financialCategoryHistory,
        ),
      ),
    );
  }

  Future<void> _onGetFinancialCategoryHistoriesEvent(
    GetFinancialCategoryHistoriesEvent event,
    Emitter<FinancialCategoryHistoryState> emit,
  ) async {
    final result = await _getFinancialCategoryHistoriesDb(NoParams());

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (financialCategoryHistories) => emit(
        state.copyWith(
          financialCategoryHistories: financialCategoryHistories,
        ),
      ),
    );
  }

  Future<void> _onResetFinancialCategoryHistoryStateEvent(
    ResetFinancialCategoryHistoryStateEvent event,
    Emitter<FinancialCategoryHistoryState> emit,
  ) async {
    emit(const FinancialCategoryHistoryState());
  }
}
