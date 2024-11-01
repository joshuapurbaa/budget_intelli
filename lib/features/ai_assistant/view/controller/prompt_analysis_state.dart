part of 'prompt_analysis_cubit.dart';

@immutable
class PromptAnalysisState {
  const PromptAnalysisState({
    this.budget,
    this.itemCategoryTransactionsByBudgetId = const [],
    this.totalActualIncome = 0,
    this.totalActualExpense = 0,
    this.loadingAnalysis = false,
    this.analysisCompleted = false,
    this.analysisError = false,
    this.analysisGenerateModel,
    this.language,
    this.textPrompt,
  });

  final Budget? budget;
  final List<ItemCategoryTransaction> itemCategoryTransactionsByBudgetId;
  final int totalActualIncome;
  final int totalActualExpense;
  final bool loadingAnalysis;
  final bool analysisCompleted;
  final bool analysisError;
  final AnalysisGenerateModel? analysisGenerateModel;
  final String? language;
  final String? textPrompt;

  PromptAnalysisState copyWith({
    Budget? budget,
    List<ItemCategoryTransaction>? itemCategoryTransactionsByBudgetId,
    int? totalActualIncome,
    int? totalActualExpense,
    bool? loadingAnalysis,
    bool? analysisCompleted,
    bool? analysisError,
    AnalysisGenerateModel? analysisGenerateModel,
    String? language,
    String? textPrompt,
  }) {
    return PromptAnalysisState(
      budget: budget ?? this.budget,
      itemCategoryTransactionsByBudgetId: itemCategoryTransactionsByBudgetId ?? this.itemCategoryTransactionsByBudgetId,
      totalActualIncome: totalActualIncome ?? this.totalActualIncome,
      totalActualExpense: totalActualExpense ?? this.totalActualExpense,
      loadingAnalysis: loadingAnalysis ?? this.loadingAnalysis,
      analysisCompleted: analysisCompleted ?? this.analysisCompleted,
      analysisError: analysisError ?? this.analysisError,
      analysisGenerateModel: analysisGenerateModel ?? this.analysisGenerateModel,
      language: language ?? this.language,
      textPrompt: textPrompt ?? this.textPrompt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PromptAnalysisState &&
        other.budget == budget &&
        listEquals(other.itemCategoryTransactionsByBudgetId, itemCategoryTransactionsByBudgetId) &&
        other.totalActualIncome == totalActualIncome &&
        other.totalActualExpense == totalActualExpense &&
        other.loadingAnalysis == loadingAnalysis &&
        other.analysisCompleted == analysisCompleted &&
        other.analysisError == analysisError &&
        other.analysisGenerateModel == analysisGenerateModel &&
        other.language == language &&
        other.textPrompt == textPrompt;
  }

  @override
  int get hashCode =>
      budget.hashCode ^
      itemCategoryTransactionsByBudgetId.hashCode ^
      totalActualIncome.hashCode ^
      totalActualExpense.hashCode ^
      loadingAnalysis.hashCode ^
      analysisCompleted.hashCode ^
      analysisError.hashCode ^
      analysisGenerateModel.hashCode ^
      language.hashCode ^
      textPrompt.hashCode;
}
