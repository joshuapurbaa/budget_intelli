import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/ai_assistant/models/budget_method_model.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  PromptCubit({
    required GeminiRepositoryModel geminiModelRepository,
    required SettingPreferenceRepo settingRepository,
  })  : _geminiModelRepository = geminiModelRepository,
        _settingRepository = settingRepository,
        super(const PromptState());

  final GeminiRepositoryModel _geminiModelRepository;
  final SettingPreferenceRepo _settingRepository;

  // Constants
  static const String _budgetPromptTemplate = '''
Recommend a monthly budget for me based on the provided data. The budget should only contain real, valid financial data.
Budget name: {budget_name}
I have the following financial data: income_amount: {income_amount}
I have the following context for my financial preferences: {additional_inputs}
{budget_method_instruction}

Provide a JSON response that has the following data structure:
Create hex_color with Analogous Color Palette for each expense object.
Four objects: budget_name, income_amount, expense, and notes. 
- budget_name: String
- income_amount: Integer
- expense: List<Map<String, dynamic>>
- notes: String.

The expense list contains objects Map<String, dynamic> with the following variables:
- group_name: String
- group_explanation: String
- color: String (ex. '#E91E63')
- item_categories: List<Map<String, dynamic>>

The item category list contains objects Map<String, dynamic> with the following variables:
- item_category_name: String
- amount: Integer

Ensure that the total amount of all item categories combined is exactly equal to {income_amount}.

Language for the response notes, group_name, group_explanation, and item_category_name should be in {language}.
Add a note that creatively explains why the budget is good based on the provided data. Include a short financial experience that inspires the budget.

Example of correct expense structure:
{
  "group_name": "Housing",
  "group_explanation": "Expenses related to living arrangements",
  "color": "#FF5733",
  "item_categories": [
    {
      "item_category_name": "Rent",
      "amount": 1000
    },
    {
      "item_category_name": "Utilities",
      "amount": 200
    }
  ]
}

Please provide the response in {language}.
''';

  // State Reset Methods
  void resetStatus() {
    emit(state.copyWith(
      generateSuccess: false,
      generateBudgetFailure: false,
    ));
  }

  void resetPrompt() {
    emit(const PromptState());
  }

  // State Update Methods
  Future<void> updateIncomeAmount(String incomeAmount) async {
    emit(state.copyWith(incomeAmount: incomeAmount));
  }

  Future<void> updateAdditionalTextInputs(String additionalTextInputs) async {
    emit(state.copyWith(additionalTextInputs: additionalTextInputs));
  }

  Future<void> updateBudgetName(String budgetName) async {
    emit(state.copyWith(budgetName: budgetName));
  }

  Future<void> updateBudgetMethod(BudgetMethodModel? budgetMethod) async {
    emit(state.copyWith(budgetMethod: budgetMethod));
  }

  // Settings Configuration Methods
  Future<void> loadLanguageSettings() async {
    try {
      final language = await _settingRepository.getLanguage();
      emit(state.copyWith(language: language));
    } on Exception catch (e) {
      debugPrint('Error loading language settings: $e');
    }
  }

  Future<void> loadCurrencySettings() async {
    try {
      final currencyCode = await _settingRepository.getCurrencyCode();
      final selectedCurrency = _findCurrencyByCode(currencyCode);
      emit(state.copyWith(currency: selectedCurrency));
    } on Exception catch (e) {
      debugPrint('Error loading currency settings: $e');
    }
  }

  CurrencyModel _findCurrencyByCode(String currencyCode) {
    return WorldCurrency.currencyList.firstWhere(
      (currency) => currency.code == currencyCode,
      orElse: () => CurrencyModel.initial,
    );
  }

  // Budget Generation Methods
  Future<void> generateBudget() async {
    _emitLoadingState();

    try {
      final generatedContent = await _generateBudgetContent();

      if (generatedContent != null) {
        await _handleSuccessfulGeneration(generatedContent);
      } else {
        _emitFailureState();
      }
    } on Exception catch (e) {
      debugPrint('Error generating budget: $e');
      _emitFailureState();
    }
  }

  void _emitLoadingState() {
    emit(state.copyWith(
      loadingGenerateBudget: true,
      textPrompt: _buildPromptText(),
    ));
  }

  Future<GenerateContentResponse?> _generateBudgetContent() async {
    final model = _geminiModelRepository.geminiProModel;
    return _generateContentFromText(model);
  }

  Future<void> _handleSuccessfulGeneration(
      GenerateContentResponse content) async {
    if (content.text == null) {
      _emitFailureState();
      return;
    }

    final budgetGenerate = BudgetGenerateModel.fromGeneratedContent(content);

    emit(state.copyWith(
      loadingGenerateBudget: false,
      generateBudgetFailure: false,
      budgetGenerate: budgetGenerate,
      generateSuccess: true,
    ));
  }

  void _emitFailureState() {
    emit(state.copyWith(
      loadingGenerateBudget: false,
      generateBudgetFailure: true,
    ));
  }

  Future<GenerateContentResponse?> _generateContentFromText(
      GenerativeModel model) async {
    try {
      final promptText = state.textPrompt ?? '';
      final mainText = TextPart(promptText);
      final response =
          await model.generateContent([Content.text(mainText.text)]);
      return response;
    } on Exception catch (e) {
      debugPrint('Error generating content from text: $e');
      return null;
    }
  }

  // Prompt Building Methods
  String _buildPromptText() {
    return _budgetPromptTemplate
        .replaceAll('{budget_name}', state.budgetName ?? '')
        .replaceAll('{income_amount}', state.incomeAmount ?? '')
        .replaceAll('{additional_inputs}', state.additionalTextInputs ?? '')
        .replaceAll(
            '{budget_method_instruction}', _getBudgetMethodInstruction())
        .replaceAll('{language}', state.language ?? 'English');
  }

  String _getBudgetMethodInstruction() {
    if (state.budgetMethod != null) {
      return 'Create a budget using the method ${state.budgetMethod?.methodName}';
    }
    return '';
  }

  // Legacy method names for backward compatibility
  @Deprecated('Use updateIncomeAmount instead')
  Future<void> setIncomeAmount({required String incomeAmount}) async {
    await updateIncomeAmount(incomeAmount);
  }

  @Deprecated('Use updateAdditionalTextInputs instead')
  Future<void> setAdditionalTextInputs(
      {required String additionalTextInputs}) async {
    await updateAdditionalTextInputs(additionalTextInputs);
  }

  @Deprecated('Use loadLanguageSettings instead')
  Future<void> setLanguage() async {
    await loadLanguageSettings();
  }

  @Deprecated('Use updateBudgetMethod instead')
  Future<void> setBudgetMethod(
      {required BudgetMethodModel? budgetMethod}) async {
    await updateBudgetMethod(budgetMethod);
  }

  @Deprecated('Use loadCurrencySettings instead')
  Future<void> setCurrency() async {
    await loadCurrencySettings();
  }

  @Deprecated('Use updateBudgetName instead')
  Future<void> setBudgetName({required String budgetName}) async {
    await updateBudgetName(budgetName);
  }

  @Deprecated('Use generateBudget instead')
  Future<void> submitPrompt() async {
    await generateBudget();
  }

  @Deprecated('Use _generateContentFromText instead')
  Future<GenerateContentResponse?> generateContentFromText(
      GenerativeModel model) async {
    return _generateContentFromText(model);
  }

  @Deprecated('Use _buildPromptText instead')
  String get initialCreateBudgetPromptEnglish => _buildPromptText();

  @Deprecated('Use _buildPromptText instead')
  String get initialCreateBudgetPrompt => _buildPromptText();
}
