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
{budget_guidelines}

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
    debugPrint('content: ${content.text}');
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
        .replaceAll('{budget_guidelines}', _getBudgetGuidelines())
        .replaceAll('{language}', state.language ?? 'English');
  }

  String _getBudgetMethodInstruction() {
    if (state.budgetMethod?.methodName == null ||
        state.budgetMethod?.methodName == 'No method') {
      return '''
## SELECTED BUDGET METHOD:
**No Specific Method Selected**
- Use general best practices for budgeting
- Focus on balanced allocation between needs, wants, and savings''';
    }

    final methodName = state.budgetMethod!.methodName;
    final methodDescription = state.budgetMethod!.methodDescription;

    return '''
## SELECTED BUDGET METHOD:
**$methodName**
$methodDescription

**IMPORTANT**: Strictly follow the allocation percentages and principles of this method when creating the budget.''';
  }

  String _getBudgetGuidelines() {
    if (state.budgetMethod?.methodName == null ||
        state.budgetMethod?.methodName == 'No method') {
      return '''
1. **Follow the 50/30/20 rule as a baseline**: 50% needs, 30% wants, 20% savings/debt repayment
2. **Prioritize essential expenses first**: Housing (max 30% of income), utilities, food, transportation
3. **Include emergency fund building**: Aim for at least 10% towards savings if possible
4. **Be realistic and practical**: Consider the user's lifestyle and constraints
5. **Account for irregular expenses**: Include annual costs divided by 12 (insurance, subscriptions)
6. **Leave buffer room**: Don't allocate 100% - leave 2-5% unallocated for unexpected expenses''';
    }

    final methodName = state.budgetMethod!.methodName;

    switch (methodName) {
      case '50/30/20':
        return '''
1. **Allocate exactly 50% for Needs**: Essential expenses like housing, utilities, food, transportation, minimum debt payments
2. **Allocate exactly 30% for Wants**: Entertainment, dining out, hobbies, non-essential shopping, lifestyle choices
3. **Allocate exactly 20% for Savings & Debt Repayment**: Emergency fund, retirement savings, extra debt payments, investments
4. **Categorize expenses carefully**: Be strict about what counts as "needs" vs "wants"
5. **Prioritize high-impact needs**: Housing should not exceed 30% of total income
6. **Build emergency fund first**: Within the 20% savings allocation, prioritize emergency fund until you have 3-6 months expenses''';

      case '60/20/20':
        return '''
1. **Allocate exactly 60% for Needs**: Essential expenses with more room for necessities
2. **Allocate exactly 20% for Wants**: More conservative approach to discretionary spending
3. **Allocate exactly 20% for Savings & Debt Repayment**: Same as 50/30/20 but with more focus on essentials
4. **Perfect for higher cost-of-living areas**: Extra 10% for needs helps cover expensive housing/utilities
5. **Maintain discipline on wants**: Smaller wants budget requires more careful planning
6. **Focus on quality needs**: Use the larger needs allocation for higher-quality essentials that last longer''';

      case '70/20/10':
        return '''
1. **Allocate exactly 70% for Needs**: Maximum focus on essential expenses
2. **Allocate exactly 20% for Wants**: Moderate discretionary spending
3. **Allocate exactly 10% for Savings & Debt Repayment**: Minimum recommended savings rate
4. **Ideal for tight budgets**: When income barely covers necessities
5. **Maximize essential quality**: Use the large needs allocation efficiently
6. **Gradually increase savings**: Work toward increasing the 10% savings rate over time''';

      case '80/10/10':
        return '''
1. **Allocate exactly 80% for Needs**: Survival-focused budgeting approach
2. **Allocate exactly 10% for Wants**: Minimal discretionary spending
3. **Allocate exactly 10% for Savings & Debt Repayment**: Emergency-only savings approach
4. **Crisis or low-income budgeting**: For those in financial difficulty
5. **Prioritize absolute essentials**: Focus only on survival needs within the 80%
6. **Plan for income increase**: This is a temporary approach while building financial stability''';

      case 'Zero-Based Budgeting (ZBB)':
        return '''
1. **Every dollar must have a purpose**: Income minus expenses must equal exactly zero
2. **Start from zero each month**: Don't carry over previous month's allocations
3. **Justify every expense**: Each category must be consciously decided upon
4. **Assign categories in priority order**: Needs first, then wants, then savings
5. **Track every transaction**: This method requires detailed monitoring
6. **Adjust monthly**: Recalculate the entire budget each month based on actual income and changing priorities''';

      case 'Pay Yourself First':
        return '''
1. **Savings comes first**: Allocate savings/investments before any other expenses
2. **Automate savings transfers**: Set up automatic transfers on payday
3. **Live on the remainder**: Use what's left after savings for all other expenses
4. **Recommended savings rate**: Aim for 20-30% if possible, minimum 10%
5. **Emergency fund priority**: Build 3-6 months expenses before other investments
6. **Increase savings over time**: Gradually increase the "pay yourself first" percentage''';

      case 'Priority-Based Budgeting':
        return '''
1. **Define clear priorities**: List your top 3-5 financial priorities
2. **Allocate to priorities first**: Fund your most important goals before discretionary spending
3. **Examples of priorities**: Children's education, healthcare, debt payoff, home purchase
4. **Flexible allocation**: Adjust percentages based on priority importance
5. **Review priorities regularly**: Reassess and adjust as life circumstances change
6. **Balance present and future**: Don't sacrifice all current enjoyment for future goals''';

      case 'Reverse Budgeting':
        return '''
1. **Savings and investments first**: Similar to "Pay Yourself First"
2. **Aggressive savings rate**: Typically 30-50% of income toward savings/investments
3. **Minimize lifestyle inflation**: Keep expenses low to maximize savings
4. **Focus on financial independence**: Build wealth for early retirement or financial freedom
5. **Automate everything**: Set up automatic transfers for savings and investments
6. **Track net worth**: Monitor progress toward financial independence goals''';

      case 'Flexible Budgeting':
        return '''
1. **Set broad category limits**: Create ranges rather than fixed amounts
2. **Allow monthly adjustments**: Modify allocations based on changing needs
3. **Maintain core priorities**: Keep essential categories stable while allowing flexibility in others
4. **Use percentage-based targets**: Work with percentages that can adjust with income changes
5. **Regular budget reviews**: Monthly check-ins to adjust allocations
6. **Emergency adaptability**: Easy to modify when unexpected expenses arise''';

      default:
        return '''
1. **Follow general budgeting principles**: Balance needs, wants, and savings appropriately
2. **Prioritize essential expenses**: Housing, utilities, food, transportation come first
3. **Include savings component**: Aim for at least 10-20% toward savings and debt repayment
4. **Be realistic and sustainable**: Create a budget you can actually follow
5. **Account for irregular expenses**: Include annual costs divided by 12
6. **Leave some buffer**: Don't allocate 100% - keep 2-5% for unexpected expenses''';
    }
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
