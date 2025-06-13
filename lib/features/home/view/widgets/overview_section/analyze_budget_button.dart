import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/home/home_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AnalyzeBudgetButton extends StatefulWidget {
  const AnalyzeBudgetButton({super.key});

  @override
  State<AnalyzeBudgetButton> createState() => _AnalyzeBudgetButtonState();
}

class _AnalyzeBudgetButtonState extends State<AnalyzeBudgetButton> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final marginLRB = getEdgeInsets(left: 16, right: 16, bottom: 10);

    return BlocListener<PromptAnalysisCubit, PromptAnalysisState>(
      listener: (context, state) {
        if (state.loadingAnalysis) {
          AppDialog.showLoading(context);
          return;
        }

        if (state.analysisError) {
          context.pop();
          AppToast.showToast(context, localize.analysisError);
          return;
        }

        if (state.analysisCompleted) {
          context.pop();
          _showDialogCompleteAnalysis(state);
        }
      },
      child: AppGlass(
        onTap: () async {
          final prefsAi = AiAssistantPreferences();
          final totalAnalyzeBudget = await prefsAi.getTotallAnalyzeBudget();

          await _validateAiCreateBudgetFeature(
            validated: totalAnalyzeBudget <= 2,
          );
        },
        margin: marginLRB,
        child: AppText(
          text: localize.analyzeYourBudgetWithAI,
          style: StyleType.bodLg,
        ),
      ),
    );
  }

  void _showDialogCompleteAnalysis(PromptAnalysisState state) {
    AppDialog.showCustomDialog(
      context,
      content: PromptAnalysisContent(state: state),
      actions: [
        AppButton(
          label: 'Ok',
          onPressed: () {
            context.pop();
          },
        ),
      ],
    ).whenComplete(
      () async {
        await _resetAiAnalysis();
      },
    );
  }

  Future<void> _resetAiAnalysis() async {
    final promptAnalysisCubit = context.read<PromptAnalysisCubit>();
    final prefsAi = AiAssistantPreferences();
    final totalAnalyze = await prefsAi.getTotallAnalyzeBudget();
    await prefsAi.setTotalAnalyzeBudget(totalAnalyze + 1);
    if (context.mounted) {
      promptAnalysisCubit.resetAnalysisCompleteValue();
    }
  }

  Future<void> _validateAiCreateBudgetFeature({required bool validated}) async {
    if (validated) {
      await context.read<PromptAnalysisCubit>().analyzeBudget();
    } else {
      AppToast.showToastError(
        context,
        textLocalizer(context).requestLimitExceeded,
      );
    }
  }
}
