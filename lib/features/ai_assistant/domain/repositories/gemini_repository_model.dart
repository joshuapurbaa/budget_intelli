import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRepositoryModel {
  GeminiRepositoryModel._internal();

  // Static field for the singleton instance.
  static final GeminiRepositoryModel _instance =
      GeminiRepositoryModel._internal();

  // Provides access to the singleton instance.
  static GeminiRepositoryModel get instance => _instance;

  // Lazily initialize the model to be used.
  late final GenerativeModel geminiProModel = _createModel();

  GenerativeModel _createModel() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    assert(
      apiKey != null && apiKey.isNotEmpty,
      'GEMINI_API_KEY must not be null or empty',
    );

    return GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey!,
      systemInstruction: Content.model([
        TextPart(_systemInstruction),
      ]),
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 100,
        topP: 0.8,
        maxOutputTokens: 2048,
        responseMimeType: 'application/json',
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
  }

  static const String _systemInstruction = '''
You are an expert Financial Advisor.
You can provide advice on how to manage finances properly and create an accurate budget.
You can also provide advice on how to invest money wisely and how to save money.
You can answer questions related to personal finance, budgeting, investing, saving, debt management, credit scores, financial planning, and financial goals.
You can analyze financial data and provide insights and recommendations.
You should be able to explain financial concepts in an easy-to-understand way.
''';
}
