import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateBudgetOptionDialog extends StatefulWidget {
  const CreateBudgetOptionDialog({
    super.key,
  });

  @override
  State<CreateBudgetOptionDialog> createState() =>
      _CreateBudgetOptionDialogState();
}

class _CreateBudgetOptionDialogState extends State<CreateBudgetOptionDialog> {
  Future<void> _validateAiCreateBudgetFeature({
    required bool validated,
  }) async {
    if (validated) {
      final result = await context.pushNamed<String>(
        MyRoute.budgetAiGenerateScreen.noSlashes(),
      );

      if (result != null) {
        context.pop(result);
      }
    } else {
      AppToast.showToastError(
        context,
        textLocalizer(context).requestLimitExceeded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return AlertDialog(
      title: Text(
        localize.createBudgetPlan,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localize.youCanCreateYourBudgetWithAIOrManuallyWhichOneDoYouPrefer,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: AppText(
            text: localize.manual,
            style: StyleType.bodLg,
          ),
        ),
        TextButton(
          onPressed: () async {
            final prefsAi = AiAssistantPreferences();
            final totalGenerateBudget = await prefsAi.getTotalGenerateBudget();

            await _validateAiCreateBudgetFeature(
              validated: totalGenerateBudget <= 2,
            );
          },
          child: AppText(
            text: localize.generateWithAI,
            style: StyleType.bodLg,
            color: context.color.primary,
          ),
        ),
      ],
    );
  }
}
