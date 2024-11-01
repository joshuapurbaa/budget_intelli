part of 'prompt_cubit.dart';

@immutable
class PromptState {
  const PromptState({
    this.loadingGenerateBudget = false,
    this.generateBudgetFailure = false,
    this.generateSuccess = false,
    this.budgetGenerate,
    this.textPrompt,
    this.incomeAmount,
    this.additionalTextInputs,
    this.language,
    this.budgetMethod,
    this.currency,
    this.budgetName,
  });

  final bool loadingGenerateBudget;
  final bool generateBudgetFailure;
  final BudgetGenerateModel? budgetGenerate;
  final String? textPrompt;
  final String? additionalTextInputs;
  final String? incomeAmount;
  final bool generateSuccess;
  final String? language;
  final BudgetMethodModel? budgetMethod;
  final CurrencyModel? currency;
  final String? budgetName;

  PromptState copyWith({
    bool? loadingGenerateBudget,
    bool? generateBudgetFailure,
    BudgetGenerateModel? budgetGenerate,
    String? textPrompt,
    String? incomeAmount,
    String? additionalTextInputs,
    bool? generateSuccess,
    String? language,
    BudgetMethodModel? budgetMethod,
    CurrencyModel? currency,
    String? budgetName,
  }) {
    return PromptState(
      loadingGenerateBudget:
          loadingGenerateBudget ?? this.loadingGenerateBudget,
      generateBudgetFailure:
          generateBudgetFailure ?? this.generateBudgetFailure,
      budgetGenerate: budgetGenerate ?? this.budgetGenerate,
      textPrompt: textPrompt ?? this.textPrompt,
      incomeAmount: incomeAmount ?? this.incomeAmount,
      additionalTextInputs: additionalTextInputs ?? this.additionalTextInputs,
      generateSuccess: generateSuccess ?? this.generateSuccess,
      language: language ?? this.language,
      budgetMethod: budgetMethod ?? this.budgetMethod,
      currency: currency ?? this.currency,
      budgetName: budgetName ?? this.budgetName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PromptState &&
        other.loadingGenerateBudget == loadingGenerateBudget &&
        other.generateBudgetFailure == generateBudgetFailure &&
        other.budgetGenerate == budgetGenerate &&
        other.textPrompt == textPrompt &&
        other.incomeAmount == incomeAmount &&
        other.additionalTextInputs == additionalTextInputs &&
        other.generateSuccess == generateSuccess &&
        other.language == language &&
        other.budgetMethod == budgetMethod &&
        other.currency == currency &&
        other.budgetName == budgetName;
  }

  @override
  int get hashCode =>
      loadingGenerateBudget.hashCode ^
      generateBudgetFailure.hashCode ^
      budgetGenerate.hashCode ^
      textPrompt.hashCode ^
      incomeAmount.hashCode ^
      additionalTextInputs.hashCode ^
      generateSuccess.hashCode ^
      language.hashCode ^
      budgetMethod.hashCode ^
      currency.hashCode ^
      budgetName.hashCode;
}
