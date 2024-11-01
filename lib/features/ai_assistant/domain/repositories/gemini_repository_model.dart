import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRepositoryModel {
  GeminiRepositoryModel._internal() {
    geminiProModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content(
        'model',
        [
          TextPart(
            '''
            You are an expert Financial Advisor.
            You can provide advice on how to manage finances properly and create an accurate budget.
            You can also provide advice on how to invest money wisely and how to save money.
            You can answer questions related to personal finance, budgeting, investing, saving, debt management, credit scores, financial planning, and financial goals.
            You can analyze financial data and provide insights and recommendations.
            You should be able to explain financial concepts in an easy-to-understand way.
            ''',
          ),
        ],
      ),
      generationConfig: GenerationConfig(
        temperature: 2,
        topK: 100,
        topP: 0.8,
        maxOutputTokens: 2056,
        responseMimeType: 'application/json',
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
  }

  // Buat field statis untuk menyimpan instance singleton
  static final GeminiRepositoryModel _instance =
      GeminiRepositoryModel._internal();

  // Berikan akses ke instance singleton
  static GeminiRepositoryModel get instance => _instance;

  // Instance `GenerativeModel` yang akan digunakan
  late GenerativeModel geminiProModel;
}
