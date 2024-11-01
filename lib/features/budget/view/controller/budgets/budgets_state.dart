part of 'budgets_cubit.dart';

@immutable
final class BudgetsState {
  const BudgetsState({
    required this.budgets,
    this.loading = false,
  });

  final List<Budget>? budgets;
  final bool loading;

  BudgetsState copyWith({
    List<Budget>? budgets,
    bool? loading,
  }) {
    return BudgetsState(
      budgets: budgets ?? this.budgets,
      loading: loading ?? this.loading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetsState &&
        listEquals(other.budgets, budgets) &&
        other.loading == loading;
  }

  @override
  int get hashCode => budgets.hashCode ^ loading.hashCode;
}
