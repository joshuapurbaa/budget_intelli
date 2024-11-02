part of 'financial_transaction_bloc.dart';

sealed class FinancialTransactionState extends Equatable {
  const FinancialTransactionState();
  
  @override
  List<Object> get props => [];
}

final class FinancialTransactionInitial extends FinancialTransactionState {}
