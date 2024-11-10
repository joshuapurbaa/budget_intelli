part of 'account_bloc.dart';

@immutable
sealed class AccountEvent {}

final class GetAccountsEvent extends AccountEvent {}

final class GetAccountsHistoryEvent extends AccountEvent {}

final class GetAllItemCategoryTransactionsEvent extends AccountEvent {}

final class GetItemCategoryHistoriesEvent extends AccountEvent {}

final class InsertAccountEvent extends AccountEvent {
  InsertAccountEvent(this.account);

  final Account account;
}

final class UpdateAccountEvent extends AccountEvent {
  UpdateAccountEvent(this.account);

  final Account account;
}

final class TransferAccountEvent extends AccountEvent {
  TransferAccountEvent({
    required this.updatedFirstAccount,
    required this.updatedSecondAccount,
  });

  final Account updatedFirstAccount;
  final Account updatedSecondAccount;
}

final class SelectAccountEvent extends AccountEvent {
  SelectAccountEvent(
    this.account,
  );

  final Account? account;
}

final class SetAccountBlocToInitial extends AccountEvent {}

final class SetInitialAccountTypes extends AccountEvent {}

final class ResetSelectedAccountStateEvent extends AccountEvent {}
