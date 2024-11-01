part of 'financial_category_history_bloc.dart';

sealed class FinancialCategoryHistoryEvent extends Equatable {
  const FinancialCategoryHistoryEvent();

  @override
  List<Object> get props => [];
}

final class InsertFinancialCategoryHistoryEvent
    extends FinancialCategoryHistoryEvent {
  const InsertFinancialCategoryHistoryEvent(this.financialCategoryHistory);

  final FinancialCategoryHistory financialCategoryHistory;

  @override
  List<Object> get props => [financialCategoryHistory];
}

final class UpdateFinancialCategoryHistoryEvent
    extends FinancialCategoryHistoryEvent {
  const UpdateFinancialCategoryHistoryEvent(this.financialCategoryHistory);

  final FinancialCategoryHistory financialCategoryHistory;

  @override
  List<Object> get props => [financialCategoryHistory];
}

final class DeleteFinancialCategoryHistoryEvent
    extends FinancialCategoryHistoryEvent {
  const DeleteFinancialCategoryHistoryEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetFinancialCategoryHistoryEvent
    extends FinancialCategoryHistoryEvent {
  const GetFinancialCategoryHistoryEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetFinancialCategoryHistoriesEvent
    extends FinancialCategoryHistoryEvent {
  const GetFinancialCategoryHistoriesEvent();

  @override
  List<Object> get props => [];
}

final class ResetFinancialCategoryHistoryStateEvent
    extends FinancialCategoryHistoryEvent {
  const ResetFinancialCategoryHistoryStateEvent();

  @override
  List<Object> get props => [];
}
