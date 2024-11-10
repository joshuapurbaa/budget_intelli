import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'financial_transaction_event.dart';
part 'financial_transaction_state.dart';

class FinancialTransactionBloc
    extends Bloc<FinancialTransactionEvent, FinancialTransactionState> {
  FinancialTransactionBloc({
    required InsertFinancialTransactionDb insertFinancialTransactionDb,
    required UpdateFinancialTransactionDb updateFinancialTransactionDb,
    required DeleteFinancialTransactionDb deleteFinancialTransactionDb,
    required GetFinancialTransactionByIdDb getFinancialTransactionDb,
    required GetAllFinancialTransactionDb getAllFinancialTransactionDb,
  })  : _insertFinancialTransactionDb = insertFinancialTransactionDb,
        _updateFinancialTransactionDb = updateFinancialTransactionDb,
        _deleteFinancialTransactionDb = deleteFinancialTransactionDb,
        _getFinancialTransactionDb = getFinancialTransactionDb,
        _getAllFinancialTransactionDb = getAllFinancialTransactionDb,
        super(FinancialTransactionState()) {
    on<InsertFinancialTransactionEvent>(_onInsertFinancialTransactionEvent);
    on<UpdateFinancialTransactionEvent>(_onUpdateFinancialTransactionEvent);
    on<DeleteFinancialTransactionEvent>(_onDeleteFinancialTransactionEvent);
    on<GetFinancialTransactionEvent>(_onGetFinancialTransactionEvent);
    on<GetAllFinancialTransactionEvent>(_onGetAllFinancialTransactionEvent);
    on<ResetFinancialTransactionStateEvent>(
      _onResetFinancialTransactionStateEvent,
    );
  }

  final InsertFinancialTransactionDb _insertFinancialTransactionDb;
  final UpdateFinancialTransactionDb _updateFinancialTransactionDb;
  final DeleteFinancialTransactionDb _deleteFinancialTransactionDb;
  final GetFinancialTransactionByIdDb _getFinancialTransactionDb;
  final GetAllFinancialTransactionDb _getAllFinancialTransactionDb;

  Future<void> _onInsertFinancialTransactionEvent(
    InsertFinancialTransactionEvent event,
    Emitter<FinancialTransactionState> emit,
  ) async {
    final result =
        await _insertFinancialTransactionDb(event.financialTransaction);

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

  Future<void> _onUpdateFinancialTransactionEvent(
    UpdateFinancialTransactionEvent event,
    Emitter<FinancialTransactionState> emit,
  ) async {
    final result =
        await _updateFinancialTransactionDb(event.financialTransaction);

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

  Future<void> _onDeleteFinancialTransactionEvent(
    DeleteFinancialTransactionEvent event,
    Emitter<FinancialTransactionState> emit,
  ) async {
    final result = await _deleteFinancialTransactionDb(event.id);

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

  Future<void> _onGetFinancialTransactionEvent(
    GetFinancialTransactionEvent event,
    Emitter<FinancialTransactionState> emit,
  ) async {
    final result = await _getFinancialTransactionDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (financialTransaction) => emit(
        state.copyWith(
          financialTransaction: financialTransaction,
        ),
      ),
    );
  }

  Future<void> _onGetAllFinancialTransactionEvent(
    GetAllFinancialTransactionEvent event,
    Emitter<FinancialTransactionState> emit,
  ) async {
    final result = await _getAllFinancialTransactionDb(NoParams());

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (financialTransactions) => emit(
        state.copyWith(
          financialTransactions: financialTransactions,
        ),
      ),
    );
  }

  Future<void> _onResetFinancialTransactionStateEvent(
    ResetFinancialTransactionStateEvent event,
    Emitter<FinancialTransactionState> emit,
  ) async {
    emit(FinancialTransactionState());
  }
}
