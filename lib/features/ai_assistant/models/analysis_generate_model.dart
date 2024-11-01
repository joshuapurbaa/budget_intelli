import 'dart:convert';

import 'package:budget_intelli/core/core.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AnalysisGenerateModel {
  AnalysisGenerateModel(
      this.overSpendCategories, this.prediction, this.recommendation,);

  factory AnalysisGenerateModel.fromGeneratedContent(
      GenerateContentResponse content,) {
    assert(content.text != null, 'Content is null');

    final validJson = cleanJson(content.text!);

    final json = jsonDecode(validJson);

    if (json is Map<String, dynamic> &&
        json.containsKey('over_spend_categories') &&
        json.containsKey('prediction') &&
        json.containsKey('recommendation')) {
      return AnalysisGenerateModel(
        (json['over_spend_categories'] as List<dynamic>)
            .map(
              (e) => OverSpendCategoriesGenerateModel.fromJson(
                  e as Map<String, dynamic>,),
            )
            .toList(),
        (json['prediction'] as List<dynamic>)
            .map(
              (e) => TrendPredictionGenerateModel.fromJson(
                  e as Map<String, dynamic>,),
            )
            .toList(),
        json['recommendation'] as String,
      );
    }
    throw JsonUnsupportedObjectError(json);
  }

  final List<OverSpendCategoriesGenerateModel> overSpendCategories;
  final List<TrendPredictionGenerateModel> prediction;
  final String recommendation;
}

class OverSpendCategoriesGenerateModel {
  OverSpendCategoriesGenerateModel(
    this.categoryName,
    this.actualAmount,
    this.totalPlan,
  );

  factory OverSpendCategoriesGenerateModel.fromJson(Map<String, dynamic> json) {
    return OverSpendCategoriesGenerateModel(
      json['category_name'] as String,
      json['actual_amount'] as int,
      json['total_plan'] as int,
    );
  }

  final String categoryName;
  final int actualAmount;
  final int totalPlan;
}

class TrendPredictionGenerateModel {
  TrendPredictionGenerateModel(this.categoryName, this.trend);

  factory TrendPredictionGenerateModel.fromJson(Map<String, dynamic> json) {
    return TrendPredictionGenerateModel(
      json['category_name'] as String,
      json['trend'] as String,
    );
  }

  final String categoryName;
  final String trend;
}
