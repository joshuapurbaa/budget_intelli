import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/ai_assistant/models/budget_method_model.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/foundation.dart';
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

  void resetStatus() {
    emit(
      state.copyWith(
        generateSuccess: false,
        generateBudgetFailure: false,
      ),
    );
  }

  void resetPrompt() {
    emit(
      const PromptState(),
    );
  }

  Future<void> setIncomeAmount({
    required String incomeAmount,
  }) async {
    emit(
      state.copyWith(
        incomeAmount: incomeAmount,
      ),
    );
  }

  Future<void> setAdditionalTextInputs({
    required String additionalTextInputs,
  }) async {
    emit(
      state.copyWith(
        additionalTextInputs: additionalTextInputs,
      ),
    );
  }

  Future<void> setLanguage() async {
    final language = await _settingRepository.getLanguage();
    emit(
      state.copyWith(language: language),
    );
  }

  Future<void> setBudgetMethod({
    required BudgetMethodModel? budgetMethod,
  }) async {
    emit(
      state.copyWith(
        budgetMethod: budgetMethod,
      ),
    );
  }

  Future<void> setCurrency() async {
    final currencyCode = await _settingRepository.getCurrencyCode();
    final selectedCurrency = WorldCurrency.currencyList.firstWhere(
      (element) => element.code == currencyCode,
      orElse: () => CurrencyModel.initial,
    );
    emit(
      state.copyWith(
        currency: selectedCurrency,
      ),
    );
  }

  Future<void> setBudgetName({
    required String budgetName,
  }) async {
    emit(
      state.copyWith(
        budgetName: budgetName,
      ),
    );
  }

  Future<void> submitPrompt() async {
    emit(
      state.copyWith(
        loadingGenerateBudget: true,
        textPrompt: initialCreateBudgetPrompt,
      ),
    );

    final model = _geminiModelRepository.geminiProModel;

    try {
      final content = await generateContentFromText(model);

      if (content != null) {
        if (content.text == null) {
          emit(
            state.copyWith(
              loadingGenerateBudget: false,
              generateBudgetFailure: true,
            ),
          );
          return;
        }

        // final outputTokenCount =
        //     await model.countTokens([Content.text(content.text!)]);

        final budgetGenerate =
            BudgetGenerateModel.fromGeneratedContent(content);

        emit(
          state.copyWith(
            loadingGenerateBudget: false,
            generateBudgetFailure: false,
            budgetGenerate: budgetGenerate,
            generateSuccess: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingGenerateBudget: false,
            generateBudgetFailure: true,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          loadingGenerateBudget: false,
          generateBudgetFailure: true,
        ),
      );
    }
  }

  Future<GenerateContentResponse?> generateContentFromText(
    GenerativeModel model,
  ) async {
    try {
      final promptText = '${state.textPrompt}';
      final mainText = TextPart(promptText);

      final response =
          await model.generateContent([Content.text(mainText.text)]);

      return response;
    } catch (error) {
      print('error :: ${error}');
      return null;
    }
  }

//   String get initialCreateBudgetPromptEnglish {
//     return '''
// Recommend a monthly budget for me based on the provided data, The budget should only contain real, valid financial data.
// Budget name: ${state.budgetName}
// I have the following financial data: income_amount: ${state.incomeAmount}
// I have the following context for my financial preferences: ${state.additionalTextInputs}
// ${state.budgetMethod != null ? 'Create a budget using the method ${state.budgetMethod?.methodName}, ${state.budgetMethod?.methodDescription}'.replaceAll('\n', ' ') : ''}
//
// Provide a JSON response that has the following data structure:
// Create hex_color with Analogous Color Palette for each expense object.
// Four objects: budget_name, income_amount, expense, and notes. budget_name: String income_amount: Integer, expense: List<Map<String, dynamic>>, notes: String.
// Expense lists are objects Map<String, dynamic> with the following variables: group_name: String, group_explanation: String, color: String (ex. '#E91E63'), item_categories: List<Map<String, dynamic>>.
// Item category list are a list of objects Map<String, dynamic> with the following variables: item_category_name: String, amount: Integer. Total amount of all item category should be equal to ${state.incomeAmount}.
//
// Language for the response notes, group_name, group_explanation, and item_category_name should be in ${state.language}.
// Add a notes that creatively explains why the budget is good based on the provided data. Tell a short financial experience that inspires the budget.
// ''';
//   }

  String get initialCreateBudgetPromptEnglish {
    return '''
Recommend a monthly budget for me based on the provided data. The budget should only contain real, valid financial data.
Budget name: ${state.budgetName}
I have the following financial data: income_amount: ${state.incomeAmount}
I have the following context for my financial preferences: ${state.additionalTextInputs}
${state.budgetMethod != null ? 'Create a budget using the method ${state.budgetMethod?.methodName}' : ''}

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

Ensure that the total amount of all item categories combined is exactly equal to ${state.incomeAmount}.

Language for the response notes, group_name, group_explanation, and item_category_name should be in ${state.language}.
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

''';
  }

  String get initialCreateBudgetPromptIndonesia {
    return '''
Rekomendasikan anggaran bulanan untuk saya berdasarkan data yang diberikan. Anggaran harus hanya berisi data keuangan yang nyata dan valid.
Budget name: ${state.budgetName}
Saya memiliki data keuangan sebagai berikut: income_amount: ${state.incomeAmount}
Saya memiliki konteks preferensi keuangan sebagai berikut: ${state.additionalTextInputs}
${state.budgetMethod != null ? 'Buat anggaran menggunakan metode ${state.budgetMethod?.methodName}' : ''}

Berikan respon dalam format JSON dengan struktur data berikut:
Buat hex_color dengan Analogous Color Palette untuk setiap objek pengeluaran.
Empat objek: budget_name, income_amount, expense, dan notes. 
- budget_name: String
- income_amount: Integer
- expense: List<Map<String, dynamic>>
- notes: String.

Daftar expense berisi objek Map<String, dynamic> dengan variabel sebagai berikut:
- group_name: String
- group_explanation: String
- color: String (contoh: '#E91E63')
- item_categories: List<Map<String, dynamic>>

Daftar item_categories berisi objek Map<String, dynamic> dengan variabel sebagai berikut:
- item_category_name: String
- amount: Integer

Pastikan bahwa jumlah total dari semua item categories sama persis dengan ${state.incomeAmount}.

Bahasa untuk notes, group_name, group_explanation, dan item_category_name harus dalam bahasa ${state.language}.
Tambahkan notes yang secara kreatif menjelaskan mengapa anggaran ini baik berdasarkan data yang diberikan. Sertakan pengalaman keuangan singkat yang menginspirasi anggaran tersebut.

Contoh struktur expense yang benar:
{
  "group_name": "Housing",
  "group_explanation": "Pengeluaran terkait tempat tinggal",
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

''';
  }

  String get initialCreateBudgetPrompt {
    if (state.language == 'Indonesia') {
      return initialCreateBudgetPromptIndonesia;
    } else {
      return initialCreateBudgetPromptEnglish;
    }
  }
}
