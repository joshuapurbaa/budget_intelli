part of 'financial_category_bloc.dart';

sealed class FinancialCategoryEvent extends Equatable {
  const FinancialCategoryEvent();

  @override
  List<Object?> get props => [];
}

final class InsertFinancialCategoryEvent extends FinancialCategoryEvent {
  const InsertFinancialCategoryEvent(this.financialCategory);

  final FinancialCategory financialCategory;

  @override
  List<Object> get props => [financialCategory];
}

final class UpdateFinancialCategoryEvent extends FinancialCategoryEvent {
  const UpdateFinancialCategoryEvent(this.financialCategory);

  final FinancialCategory financialCategory;

  @override
  List<Object> get props => [financialCategory];
}

final class DeleteFinancialCategoryEvent extends FinancialCategoryEvent {
  const DeleteFinancialCategoryEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetFinancialCategoryEvent extends FinancialCategoryEvent {
  const GetFinancialCategoryEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetAllFinancialCategoryEvent extends FinancialCategoryEvent {
  const GetAllFinancialCategoryEvent();

  @override
  List<Object> get props => [];
}

final class ResetFinancialCategoryStateEvent extends FinancialCategoryEvent {
  const ResetFinancialCategoryStateEvent();

  @override
  List<Object> get props => [];
}

final class SetSelectedFinancialCategoryEvent extends FinancialCategoryEvent {
  const SetSelectedFinancialCategoryEvent(this.financialCategory);

  final FinancialCategory? financialCategory;

  @override
  List<Object?> get props => [financialCategory];
}
