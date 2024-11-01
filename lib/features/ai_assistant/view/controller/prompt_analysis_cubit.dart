import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'prompt_analysis_state.dart';

class PromptAnalysisCubit extends Cubit<PromptAnalysisState> {
  PromptAnalysisCubit({
    required GeminiRepositoryModel geminiModelRepository,
    required SettingPreferenceRepo settingRepository,
  })  : _geminiModelRepository = geminiModelRepository,
        _settingRepository = settingRepository,
        super(
          const PromptAnalysisState(),
        );

  final GeminiRepositoryModel _geminiModelRepository;
  final SettingPreferenceRepo _settingRepository;

  void resetPrompt() {
    emit(
      const PromptAnalysisState(),
    );
  }

  Future<void> setLanguage() async {
    final language = await _settingRepository.getLanguage();

    emit(
      state.copyWith(language: language),
    );
  }

  Future<void> setBudget({
    required Budget? budget,
  }) async {
    emit(
      state.copyWith(
        budget: budget,
      ),
    );
  }

  Future<void> setTotalActualIncome({
    required int totalActualIncome,
  }) async {
    emit(
      state.copyWith(
        totalActualIncome: totalActualIncome,
      ),
    );
  }

  Future<void> setTotalActualExpense({
    required int totalActualExpense,
  }) async {
    emit(
      state.copyWith(
        totalActualExpense: totalActualExpense,
      ),
    );
  }

  Future<void> setItemCategoryTransactionsByBudgetId({
    required List<ItemCategoryTransaction> itemCategoryTransactionsByBudgetId,
  }) async {
    emit(
      state.copyWith(
        itemCategoryTransactionsByBudgetId: itemCategoryTransactionsByBudgetId,
      ),
    );
  }

  Future<void> analyzeBudget() async {
    emit(
      state.copyWith(
        loadingAnalysis: true,
        textPrompt: analysisPrompt,
      ),
    );

    final model = _geminiModelRepository.geminiProModel;

    try {
      final content = await generateContentFromText(model);

      if (content.text == null) {
        emit(
          state.copyWith(
            loadingAnalysis: false,
            analysisError: true,
          ),
        );
        return;
      }

      final analysisGenerated = AnalysisGenerateModel.fromGeneratedContent(content);

      emit(
        state.copyWith(
          loadingAnalysis: false,
          analysisCompleted: true,
          analysisGenerateModel: analysisGenerated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadingAnalysis: false,
        ),
      );
    }
  }

  void resetAnalysisCompleteValue() {
    emit(state.copyWith(analysisCompleted: false));
  }

  Future<GenerateContentResponse> generateContentFromText(
    GenerativeModel model,
  ) async {
    final promptText = '${state.textPrompt}';
    final mainText = TextPart(promptText);

    // final tokenCount = await model.countTokens([Content.text(mainText.text)]);

    // print('token count :: ${tokenCount.totalTokens}');

    return model.generateContent(
      [Content.text(mainText.text)],
    );
  }

  String get budgetAnalysisPromptID {
    return '''
    Saya memiliki dua set data yang ingin saya analisis: data budget yang sudah dibuat sebelumnya dan data transaksi yang terjadi sejak saat itu.
    Berikut adalah data yang tersedia:  
    
    1. Data Budget:
    - Nama budget: ${state.budget?.budgetName}
    - Total anggaran pengeluaran: ${state.budget?.totalPlanExpense}
    - Total anggaran pemasukan: ${state.budget?.totalPlanIncome}
    - Periode budget: ${state.budget?.startDate} - ${state.budget?.endDate}
    - Detail kategori budget:
    ${state.budget?.groupCategories?.map((e) => '* ${e.groupName}: ${e.itemCategoryHistories.map((e) => '${e.name}: ${e.amount}').join(', ')}').join('\n')}
    
    
    2. Data Transaksi:
    - Total transaksi pengeluaran: ${state.totalActualExpense}
    - Total transaksi pemasukan: ${state.totalActualIncome}
    - Detail Transaksi:
    ${state.itemCategoryTransactionsByBudgetId.map((e) => '* ${e.categoryName}: ${e.amount}, ${e.type == 'income' ? 'diterima' : 'dihabiskan'} di ${e.spendOn}').join('\n')}
    
    Tugas anda sebagai Model AI yaitu untuk:
    Mengidentifikasi kategori-kategori pengeluaran yang telah melebihi anggaran bulanan.
    Memberikan prediksi atau tren pengeluaran untuk kategori-kategori tertentu berdasarkan data transaksi terbaru.
    Memberikan saran atau rekomendasi untuk pengelolaan budget berdasarkan analisis dari data yang tersedia.
    Silakan berikan analisis berdasarkan data tersebut.
    
    Berikan respons JSON yang memiliki struktur data berikut:
    Dua objek utama dan satu String: over_spend_categories, prediction, dan recommendation.
    - Kategori pengeluaran yang melebihi anggaran bulanan: over_spend_categories: List<Map<String, dynamic>>. didalamnya terdapat variabel: category_name: String, actual_amount: Integer, total_plan: Integer.
    - Prediksi atau tren pengeluaran untuk kategori-kategori tertentu. prediction: List<Map<String, dynamic>>. didalamnya terdapat variabel: category_name: String, trend: String.
    - Saran atau rekomendasi untuk pengelolaan budget berdasarkan analisis dari data yang tersedia. recommendation: String.
    
    Bahasa untuk nilai-nilai dari 'trend' dan 'recommendation' dalam JSON harus dalam Bahasa Indonesia. 
    ''';
  }

  String get budgetAnalysisPromptEN {
    return '''
    I have two sets of data that I want to analyze: the budget data that has been created previously and the transaction data that has occurred since then.
    Here is the available data:
    
    1. Budget Data:
    - Budget name: ${state.budget?.budgetName}
    - Total planned expense budget: ${state.budget?.totalPlanExpense}
    - Total planned income budget: ${state.budget?.totalPlanIncome}
    - Budget period: ${state.budget?.startDate} - ${state.budget?.endDate}
    - Detail budget categories:
    ${state.budget?.groupCategories?.map((e) => '* ${e.groupName}: ${e.itemCategoryHistories.map((e) => '${e.name}: ${e.amount}').join(', ')}').join('\n')}
    
    
    2. Transaction Data:
    - Total actual expense transaction: ${state.totalActualExpense}
    - Total actual income transaction: ${state.totalActualIncome}
    - Transaction details:
    ${state.itemCategoryTransactionsByBudgetId.map((e) => '* ${e.categoryName}: ${e.amount}, ${e.type == 'income' ? 'received' : 'spent'} on ${e.spendOn}').join('\n')}
    
    Your task as an AI Model is to:
    Identify expense categories that have exceeded the monthly budget.
    Provide predictions or trends of expenses for certain categories based on the latest transaction data.
    Provide advice or recommendations for budget management based on the analysis of the available data.
    Please provide an analysis based on the data.
    
    Provide a JSON response that has the following data structure:
    Two main objects and one String: over_spend_categories, prediction, and recommendation.
    - Expense categories that have exceeded the monthly budget: over_spend_categories: List<Map<String, dynamic>>. inside it contains the variables: category_name: String, actual_amount: Integer, total_plan: Integer.
    - Predictions or trends of expenses for certain categories. prediction: List<Map<String, dynamic>>. inside it contains the variables: category_name: String, trend: String.
    - Advice or recommendations for budget management based on the analysis of the available data. recommendation: String.
    
    The language for the values of 'trend' and 'recommendation' in JSON should be in English.
    ''';
  }

  String get analysisPrompt {
    if (state.language == 'Indonesia') {
      return budgetAnalysisPromptID;
    } else {
      return budgetAnalysisPromptEN;
    }
  }
}
