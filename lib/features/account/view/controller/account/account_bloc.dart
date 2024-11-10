import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required InsertAccountUsecase insertAccountUsecase,
    required GetAccountsUsecase getAccountsUsecase,
    required SettingPreferenceRepo settingPreferenceRepo,
    required UpdateAccountUsecase updateAccountUsecase,
    required GetAccountHistoriesUsecase getAccountHistoriesUsecase,
    required GetAllItemCategoryTransactions getAllItemCategoryTransactions,
    required GetItemCategoryHistoriesUsecase getItemCategoryHistoriesUsecase,
  })  : _insertAccountUsecase = insertAccountUsecase,
        _getAccountsUsecase = getAccountsUsecase,
        _preferenceRepository = settingPreferenceRepo,
        _updateAccountUsecase = updateAccountUsecase,
        _getAccountHistoriesUsecase = getAccountHistoriesUsecase,
        _getAllItemCategoryTransactions = getAllItemCategoryTransactions,
        _getItemCategoryHistoriesUsecase = getItemCategoryHistoriesUsecase,
        super(
          const AccountState(
            accounts: [],
            selectedAccount: null,
          ),
        ) {
    on<InsertAccountEvent>(_onInsertAccountEvent);
    on<GetAccountsEvent>(_onGetAccountsEvent);
    on<SelectAccountEvent>(_onSelectAccountEvent);
    on<SetAccountBlocToInitial>(_onSetAccountBlocToInitial);
    on<SetInitialAccountTypes>(_onSetInitialAccountTypes);
    on<UpdateAccountEvent>(_onUpdateAccountEvent);
    on<GetAccountsHistoryEvent>(_onGetAccountsHistoryEvent);
    on<GetItemCategoryHistoriesEvent>(_onGetItemCategoriesEvent);
    on<GetAllItemCategoryTransactionsEvent>(
      _onGetAllItemCategoryTransactionsEvent,
    );
    on<TransferAccountEvent>(_onTransferAccountEvent);
    on<ResetSelectedAccountStateEvent>(_onResetSelectedAccountStateEvent);
  }

  final InsertAccountUsecase _insertAccountUsecase;
  final GetAccountsUsecase _getAccountsUsecase;
  final SettingPreferenceRepo _preferenceRepository;
  final UpdateAccountUsecase _updateAccountUsecase;
  final GetAccountHistoriesUsecase _getAccountHistoriesUsecase;
  final GetAllItemCategoryTransactions _getAllItemCategoryTransactions;
  final GetItemCategoryHistoriesUsecase _getItemCategoryHistoriesUsecase;

  Future<void> _onInsertAccountEvent(
    InsertAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _insertAccountUsecase(event.account);

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          insertSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          insertSuccess: true,
          newAccountParam: event.account,
        ),
      ),
    );
  }

  Future<void> _onUpdateAccountEvent(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _updateAccountUsecase(event.account);

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          updateSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          updateSuccess: true,
          newAccountParam: event.account,
        ),
      ),
    );
  }

  Future<void> _onTransferAccountEvent(
    TransferAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    final updateFirstAccountResult =
        await _updateFirstAccount(event.updatedFirstAccount);

    if (updateFirstAccountResult) {
      final result = await _updateAccountUsecase(event.updatedSecondAccount);

      result.fold(
        (failure) => emit(
          state.copyWith(error: failure.message, transferSuccess: false),
        ),
        (_) => emit(
          state.copyWith(
            transferSuccess: true,
            updatedFirstAccountParam: event.updatedFirstAccount,
            updatedSecondAccountParam: event.updatedSecondAccount,
          ),
        ),
      );
    }
  }

  Future<bool> _updateFirstAccount(Account firstAccount) async {
    final result = await _updateAccountUsecase(firstAccount);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  Future<void> _onGetAccountsEvent(
    GetAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _getAccountsUsecase(NoParams());
    var totalBalance = 0.0;

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
        ),
      ),
      (accounts) {
        for (final account in accounts) {
          totalBalance += account.amount;
        }

        emit(
          state.copyWith(
            accounts: accounts,
            totalBalance: totalBalance,
          ),
        );
      },
    );
  }

  Future<void> _onGetAccountsHistoryEvent(
    GetAccountsHistoryEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _getAccountHistoriesUsecase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
        ),
      ),
      (accountHistory) => emit(
        state.copyWith(
          accountHistory: accountHistory,
        ),
      ),
    );
  }

  Future<void> _onGetAllItemCategoryTransactionsEvent(
    GetAllItemCategoryTransactionsEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _getAllItemCategoryTransactions(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
        ),
      ),
      (itemCategoryTransactions) => emit(
        state.copyWith(
          itemCategoryTransactions: itemCategoryTransactions,
        ),
      ),
    );
  }

  Future<void> _onGetItemCategoriesEvent(
    GetItemCategoryHistoriesEvent event,
    Emitter<AccountState> emit,
  ) async {
    final result = await _getItemCategoryHistoriesUsecase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
        ),
      ),
      (itemCategories) => emit(
        state.copyWith(
          itemCategoryHistories: itemCategories,
        ),
      ),
    );
  }

  Future<void> _onSelectAccountEvent(
    SelectAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedAccount: event.account,
      ),
    );
  }

  Future<void> _onSetAccountBlocToInitial(
    SetAccountBlocToInitial event,
    Emitter<AccountState> emit,
  ) async {
    emit(
      AccountState.initial(),
    );
  }

  Future<void> _onSetInitialAccountTypes(
    SetInitialAccountTypes event,
    Emitter<AccountState> emit,
  ) async {
    var accountTypes = <String>[];

    final language = await _preferenceRepository.getLanguage();

    if (language != 'Indonesia') {
      accountTypes = ['Cash', 'Bank', 'E-Money', 'Credit Card'];
    } else {
      accountTypes = ['Kas', 'Bank', 'E-Money', 'Kartu Kredit'];
    }

    emit(
      state.copyWith(
        accountTypes: accountTypes,
      ),
    );
  }

  Future<void> _onResetSelectedAccountStateEvent(
    ResetSelectedAccountStateEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(
        
      ),
    );
  }
}
