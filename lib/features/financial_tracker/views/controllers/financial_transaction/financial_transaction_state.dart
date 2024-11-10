part of 'financial_transaction_bloc.dart';

final class FinancialTransactionState extends Equatable {
  FinancialTransactionState({
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
    this.financialTransactions = const [],
    this.financialTransaction,
    this.errorMessage,
  });

  final bool insertSuccess;
  final bool updateSuccess;
  final bool deleteSuccess;
  final String? errorMessage;
  final List<FinancialTransaction> financialTransactions;
  final FinancialTransaction? financialTransaction;

  FinancialTransactionState copyWith({
    bool? insertSuccess,
    bool? updateSuccess,
    bool? deleteSuccess,
    List<FinancialTransaction>? financialTransactions,
    FinancialTransaction? financialTransaction,
    String? errorMessage,
    Member? selectedMember,
  }) {
    return FinancialTransactionState(
      insertSuccess: insertSuccess ?? this.insertSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
      financialTransactions:
          financialTransactions ?? this.financialTransactions,
      financialTransaction: financialTransaction ?? this.financialTransaction,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        insertSuccess,
        updateSuccess,
        deleteSuccess,
        financialTransactions,
        financialTransaction,
        errorMessage,
      ];
}
