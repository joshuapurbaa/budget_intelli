part of 'prompt_cubit.dart';

class PromptState extends Equatable {
  const PromptState({
    this.loadingGenerateBudget = false,
    this.generateBudgetFailure = false,
    this.generateSuccess = false,
    this.networkError = false,
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
  final bool networkError;
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
    bool? networkError,
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
      networkError: networkError ?? this.networkError,
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
  List<Object?> get props => [
        loadingGenerateBudget,
        generateBudgetFailure,
        networkError,
        budgetGenerate,
        textPrompt,
        incomeAmount,
        additionalTextInputs,
        generateSuccess,
        language,
        budgetMethod,
        currency,
        budgetName,
      ];
}
