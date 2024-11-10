import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_portfolio_db_event.dart';
part 'my_portfolio_db_state.dart';

class MyPortfolioDbBloc extends Bloc<MyPortfolioDbEvent, MyPortfolioDbState> {
  MyPortfolioDbBloc({
    required InsertMyPortfolioDb insertMyPortfolioDb,
    required UpdateMyPortfolioDb updateMyPortfolioDb,
    required GetMyPortfolioByIdDb getMyPortfolioByIdDb,
    required GetMyPortfolioListDb getMyPortfolioListDb,
    required DeleteMyPortfolioDb deleteMyPortfolioDb,
  })  : _insertMyPortfolioDb = insertMyPortfolioDb,
        _updateMyPortfolioDb = updateMyPortfolioDb,
        _getMyPortfolioByIdDb = getMyPortfolioByIdDb,
        _getMyPortfolioListDb = getMyPortfolioListDb,
        _deleteMyPortfolioDb = deleteMyPortfolioDb,
        super(
          const MyPortfolioDbState(),
        ) {
    on<InsertMyPortfolioDbEvent>(_onInsertMyPortfolioDbEvent);
    on<UpdateMyPortfolioDbEvent>(_onUpdateMyPortfolioDbEvent);
    on<DeleteMyPortfolioDbEvent>(_onDeleteMyPortfolioDbEvent);
    on<GetMyPortfolioByIdDbEvent>(_onGetMyPortfolioByIdDbEvent);
    on<GetMyPortfolioListDbEvent>(_onGetMyPortfolioListDbEvent);
  }

  final InsertMyPortfolioDb _insertMyPortfolioDb;
  final UpdateMyPortfolioDb _updateMyPortfolioDb;
  final GetMyPortfolioByIdDb _getMyPortfolioByIdDb;
  final GetMyPortfolioListDb _getMyPortfolioListDb;
  final DeleteMyPortfolioDb _deleteMyPortfolioDb;

  Future<void> _onInsertMyPortfolioDbEvent(
    InsertMyPortfolioDbEvent event,
    Emitter<MyPortfolioDbState> emit,
  ) async {
    final result = await _insertMyPortfolioDb(event.myPortfolio);

    result.fold(
      (fail) => emit(
        state.copyWith(
          insertMyPortfolioSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertMyPortfolioSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateMyPortfolioDbEvent(
    UpdateMyPortfolioDbEvent event,
    Emitter<MyPortfolioDbState> emit,
  ) async {
    final result = await _updateMyPortfolioDb(event.myPortfolio);

    result.fold(
      (fail) => emit(
        state.copyWith(
          updateMyPortfolioSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateMyPortfolioSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onDeleteMyPortfolioDbEvent(
    DeleteMyPortfolioDbEvent event,
    Emitter<MyPortfolioDbState> emit,
  ) async {
    final result = await _deleteMyPortfolioDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          deleteMyPortfolioSuccess: false,
          errorMessage: fail.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteMyPortfolioSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onGetMyPortfolioByIdDbEvent(
    GetMyPortfolioByIdDbEvent event,
    Emitter<MyPortfolioDbState> emit,
  ) async {
    final result = await _getMyPortfolioByIdDb(event.id);

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (myPortfolio) => emit(
        state.copyWith(
          myPortfolio: myPortfolio,
        ),
      ),
    );
  }

  Future<void> _onGetMyPortfolioListDbEvent(
    GetMyPortfolioListDbEvent event,
    Emitter<MyPortfolioDbState> emit,
  ) async {
    final result = await _getMyPortfolioListDb(NoParams());

    result.fold(
      (fail) => emit(
        state.copyWith(
          errorMessage: fail.message,
        ),
      ),
      (myPortfolios) => emit(
        state.copyWith(
          myPortfolios: myPortfolios,
          insertMyPortfolioSuccess: false,
        ),
      ),
    );
  }
}
