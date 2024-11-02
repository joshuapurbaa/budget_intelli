part of 'financial_transaction_bloc.dart';

sealed class FinancialTransactionEvent extends Equatable {
  const FinancialTransactionEvent();

  @override
  List<Object?> get props => [];
}

final class InsertFinancialTransactionEvent extends FinancialTransactionEvent {
  const InsertFinancialTransactionEvent(this.financialTransaction);

  final FinancialTransaction financialTransaction;

  @override
  List<Object> get props => [financialTransaction];
}

final class UpdateFinancialTransactionEvent extends FinancialTransactionEvent {
  const UpdateFinancialTransactionEvent(this.financialTransaction);

  final FinancialTransaction financialTransaction;

  @override
  List<Object> get props => [financialTransaction];
}

final class DeleteFinancialTransactionEvent extends FinancialTransactionEvent {
  const DeleteFinancialTransactionEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetFinancialTransactionEvent extends FinancialTransactionEvent {
  const GetFinancialTransactionEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetAllFinancialTransactionEvent extends FinancialTransactionEvent {
  const GetAllFinancialTransactionEvent();

  @override
  List<Object> get props => [];
}

final class ResetFinancialTransactionStateEvent
    extends FinancialTransactionEvent {
  const ResetFinancialTransactionStateEvent();

  @override
  List<Object> get props => [];
}
