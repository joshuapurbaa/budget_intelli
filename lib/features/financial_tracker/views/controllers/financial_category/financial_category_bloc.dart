import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:budget_intelli/init_dependencies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'financial_category_event.dart';
part 'financial_category_state.dart';

class FinancialCategoryBloc
    extends Bloc<FinancialCategoryEvent, FinancialCategoryState> {
  FinancialCategoryBloc({
    required InsertFinancialCategoryDb insertFinancialCategoryDb,
    required UpdateFinancialCategoryDb updateFinancialCategoryDb,
    required DeleteFinancialCategoryDb deleteFinancialCategoryDb,
    required GetFinancialCategoryDb getFinancialCategoryDb,
    required GetAllFinancialCategoryDb getFinancialCategoriesDb,
  })  : _insertFinancialCategoryDb = insertFinancialCategoryDb,
        _updateFinancialCategoryDb = updateFinancialCategoryDb,
        _deleteFinancialCategoryDb = deleteFinancialCategoryDb,
        _getFinancialCategoryDb = getFinancialCategoryDb,
        _getFinancialCategoriesDb = getFinancialCategoriesDb,
        super(const FinancialCategoryState()) {
    on<InsertFinancialCategoryEvent>(_onInsertFinancialCategoryEvent);
    on<UpdateFinancialCategoryEvent>(_onUpdateFinancialCategoryEvent);
    on<DeleteFinancialCategoryEvent>(_onDeleteFinancialCategoryEvent);
    on<GetFinancialCategoryEvent>(_onGetFinancialCategoryEvent);
    on<GetAllFinancialCategoryEvent>(_onGetAllFinancialCategoryEvent);
    on<ResetFinancialCategoryStateEvent>(_onResetFinancialCategoryStateEvent);
    on<SetSelectedFinancialCategoryEvent>(_onSetSelectedFinancialCategoryEvent);
  }

  final InsertFinancialCategoryDb _insertFinancialCategoryDb;
  final UpdateFinancialCategoryDb _updateFinancialCategoryDb;
  final DeleteFinancialCategoryDb _deleteFinancialCategoryDb;
  final GetFinancialCategoryDb _getFinancialCategoryDb;
  final GetAllFinancialCategoryDb _getFinancialCategoriesDb;

  Future<void> _onInsertFinancialCategoryEvent(
    InsertFinancialCategoryEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    final result = await _insertFinancialCategoryDb(event.financialCategory);

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

  Future<void> _onUpdateFinancialCategoryEvent(
    UpdateFinancialCategoryEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    final result = await _updateFinancialCategoryDb(event.financialCategory);

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

  Future<void> _onDeleteFinancialCategoryEvent(
    DeleteFinancialCategoryEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    final result = await _deleteFinancialCategoryDb(event.id);

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

  Future<void> _onGetFinancialCategoryEvent(
    GetFinancialCategoryEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    final result = await _getFinancialCategoryDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (financialCategory) => emit(
        state.copyWith(
          financialCategory: financialCategory,
        ),
      ),
    );
  }

  Future<void> _onGetAllFinancialCategoryEvent(
    GetAllFinancialCategoryEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    final result = await _getFinancialCategoriesDb(NoParams());
    final language =
        await serviceLocator<SettingPreferenceRepo>().getLanguage();

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (financialCategories) {
        final categories = financialCategoryHardcodedEN
          ..addAll(financialCategories);
        emit(
          state.copyWith(
            financialCategories: categories,
            language: language,
          ),
        );
      },
    );
  }

  Future<void> _onSetSelectedFinancialCategoryEvent(
    SetSelectedFinancialCategoryEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedFinancialCategory: event.financialCategory,
      ),
    );
  }

  Future<void> _onResetFinancialCategoryStateEvent(
    ResetFinancialCategoryStateEvent event,
    Emitter<FinancialCategoryState> emit,
  ) async {
    emit(const FinancialCategoryState());
  }
}
