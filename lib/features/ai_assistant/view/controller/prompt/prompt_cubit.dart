import 'dart:io';

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
You are an expert financial advisor with 15+ years of experience helping people create practical, balanced budgets. Create a personalized monthly budget recommendation based on the provided information.

## CLIENT INFORMATION:
- Budget Name: {budget_name}
- Monthly Income: {income_amount}
- Additional Context: {additional_inputs}
{budget_method_instruction}

## BUDGET CREATION GUIDELINES:
1. **Follow the 50/30/20 rule as a baseline**: 50% needs, 30% wants, 20% savings/debt repayment
2. **Prioritize essential expenses first**: Housing (max 30% of income), utilities, food, transportation
3. **Include emergency fund building**: Aim for at least 10% towards savings if possible
4. **Be realistic and practical**: Consider the user's lifestyle and constraints
5. **Account for irregular expenses**: Include annual costs divided by 12 (insurance, subscriptions)
6. **Leave buffer room**: Don't allocate 100% - leave 2-5% unallocated for unexpected expenses

## EXPENSE CATEGORIZATION STRATEGY:
- **Housing** (25-35%): Rent/mortgage, utilities, maintenance, insurance
- **Transportation** (10-20%): Car payments, gas, insurance, public transport, maintenance
- **Food & Dining** (10-15%): Groceries, dining out, coffee, snacks
- **Personal Care** (3-7%): Healthcare, grooming, clothing, fitness
- **Entertainment** (5-10%): Hobbies, streaming, social activities, travel
- **Financial** (15-25%): Savings, emergency fund, debt payments, investments
- **Miscellaneous** (3-8%): Gifts, charity, unexpected expenses, subscriptions

## JSON RESPONSE REQUIREMENTS:
Return a valid JSON object with exactly this structure:

```json
{
  "budget_name": "String",
  "income_amount": Integer,
  "expense": [
    {
      "group_name": "String",
      "group_explanation": "String - Brief explanation of why this category is important",
      "color": "String - Hex color code using analogous color palette",
      "item_categories": [
        {
          "item_category_name": "String",
          "amount": Integer
        }
      ]
    }
  ],
  "notes": "String - Comprehensive explanation with financial wisdom"
}
```

## CRITICAL REQUIREMENTS:
- Total of ALL item category amounts MUST equal exactly {income_amount}
- Use a professional analogous color palette (complementary colors that work well together)
- Provide 4-7 expense groups with 2-5 item categories each
- All text in {language} language
- Include practical, actionable financial advice in notes

## NOTES SECTION REQUIREMENTS:
Your notes should include:
1. **Budget Philosophy**: Explain the approach used and why it works
2. **Key Recommendations**: 3-4 specific actionable tips
3. **Adjustment Guidance**: How to modify the budget based on changing circumstances
4. **Success Metrics**: What indicates this budget is working
5. **Inspirational Element**: Brief story or principle that motivates good financial habits

## EXAMPLE STRUCTURE:
{
  "group_name": "Essential Living",
  "group_explanation": "Core expenses required for basic living standards and stability",
  "color": "#2E7D5A",
  "item_categories": [
    {
      "item_category_name": "Housing & Utilities",
      "amount": 1200
    },
    {
      "item_category_name": "Groceries & Essentials",
      "amount": 400
    }
  ]
}

Create a budget that balances financial responsibility with quality of life. Respond ONLY with valid JSON in {language}.
''';

  // State Reset Methods
  void resetStatus() {
    emit(state.copyWith(
      generateSuccess: false,
      generateBudgetFailure: false,
      networkError: false,
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
    } on SocketException catch (e) {
      debugPrint('Network error generating budget: $e');
      _emitNetworkErrorState();
    } on HttpException catch (e) {
      debugPrint('HTTP error generating budget: $e');
      _emitNetworkErrorState();
    } on Exception catch (e) {
      debugPrint('Error generating budget: $e');
      _emitFailureState();
    }
  }

  // Helper method to retry budget generation with exponential backoff
  Future<void> retryGenerateBudget({int maxRetries = 3}) async {
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        debugPrint('Retry attempt $attempt/$maxRetries for budget generation');

        // Check connectivity before attempting
        if (!await _checkConnectivity()) {
          debugPrint('No connectivity detected on attempt $attempt');
          if (attempt == maxRetries) {
            _emitNetworkErrorState();
            return;
          }
          await Future<void>.delayed(Duration(seconds: attempt * 2));
          continue;
        }

        await generateBudget();
        return; // Success, exit retry loop
      } on SocketException catch (e) {
        debugPrint('Network error on attempt $attempt: $e');
        if (attempt == maxRetries) {
          // Final attempt failed, emit network error
          _emitNetworkErrorState();
          return;
        }
        // Wait before retrying (exponential backoff)
        await Future<void>.delayed(Duration(seconds: attempt * 2));
      } on Exception catch (e) {
        debugPrint('Non-network error on attempt $attempt: $e');
        _emitFailureState();
        return; // Don't retry on non-network errors
      }
    }
  }

  // Helper method to check basic connectivity
  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
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
      networkError: false,
    ));
  }

  void _emitNetworkErrorState() {
    emit(state.copyWith(
      loadingGenerateBudget: false,
      generateBudgetFailure: true,
      networkError: true,
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
    } on SocketException catch (e) {
      debugPrint('Network error generating content from text: $e');
      rethrow; // Re-throw to be caught by the calling method
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
