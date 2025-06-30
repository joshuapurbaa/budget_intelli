import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:flutter/material.dart';

class PromptAnalysisContent extends StatelessWidget {
  const PromptAnalysisContent({required this.state, super.key});

  final PromptAnalysisState state;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final recommendation = state.analysisGenerateModel?.recommendation;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: AppText(
              text: localize.analysisResult,
              style: StyleType.headMed,
              textAlign: TextAlign.center,
            ),
          ),
          Gap.vertical(16),
          AppText(
            text: localize.overSpendCategory,
            style: StyleType.bodLg,
          ),
          Gap.vertical(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              state.analysisGenerateModel?.overSpendCategories.length ?? 0,
              (index) {
                final overBudgetCategory =
                    state.analysisGenerateModel?.overSpendCategories[index];
                final categoryName = overBudgetCategory?.categoryName;
                final actualAmount = overBudgetCategory?.actualAmount ?? 0;
                final planAmount = overBudgetCategory?.totalPlan ?? 0;
                final actualAmountStr = NumberFormatter.formatToMoneyInt(
                  context,
                  actualAmount,
                );
                final planAmountStr = NumberFormatter.formatToMoneyInt(
                  context,
                  planAmount,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: '$categoryName',
                      style: StyleType.bodMed,
                      fontWeight: FontWeight.w500,
                    ),
                    Gap.vertical(5),
                    AppText(
                      text: '${localize.actual}: $actualAmountStr',
                      style: StyleType.bodMed,
                    ),
                    Gap.vertical(5),
                    AppText(
                      text: '${localize.planned}: $planAmountStr',
                      style: StyleType.bodMed,
                    ),
                  ],
                );
              },
            ),
          ),
          Gap.vertical(16),
          AppText(
            text: localize.prediction,
            style: StyleType.bodLg,
          ),
          Gap.vertical(10),
          Column(
            children: List.generate(
              state.analysisGenerateModel?.overSpendCategories.length ?? 0,
              (index) {
                final trendPrediction =
                    state.analysisGenerateModel?.prediction[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: '${trendPrediction?.categoryName}',
                      style: StyleType.bodMed,
                      fontWeight: FontWeight.w500,
                    ),
                    AppText(
                      text: '${localize.trend}: ${trendPrediction?.trend}',
                      style: StyleType.bodMed,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                );
              },
            ),
          ),
          Gap.vertical(16),
          AppText(
            text: localize.recommendation,
            style: StyleType.bodLg,
          ),
          Gap.vertical(10),
          AppText(
            text: recommendation ?? '',
            style: StyleType.bodMed,
          ),
        ],
      ),
    );
  }
}
