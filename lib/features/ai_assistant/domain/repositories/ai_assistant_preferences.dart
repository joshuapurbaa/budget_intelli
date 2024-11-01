import 'package:shared_preferences/shared_preferences.dart';

class AiAssistantPreferences {
  static const String totalGenerateBudgetKey = 'total_generate_budget';
  static const String totalAnalyzeBudgetKey = 'total_analyze_budget';

  Future<void> setTotalGenerateBudget(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(totalGenerateBudgetKey, value);
  }

  Future<int> getTotalGenerateBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt(totalGenerateBudgetKey) ?? 0;
    return total;
  }

  Future<void> setTotalAnalyzeBudget(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(totalAnalyzeBudgetKey, value);
  }

  Future<int> getTotallAnalyzeBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt(totalAnalyzeBudgetKey) ?? 0;
    return total;
  }
}
