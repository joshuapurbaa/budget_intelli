import 'dart:ui';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class CreateBudgetOptionDialog extends StatelessWidget {
  const CreateBudgetOptionDialog({
    required this.onManualPressed,
    required this.onAiPressed,
    super.key,
  });

  final VoidCallback onManualPressed;
  final VoidCallback onAiPressed;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: getEdgeInsetsAll(16),
          width: context.screenWidth * 0.9,
          decoration: BoxDecoration(
            color: context.color.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: localize.createBudgetPlan,
                style: StyleType.headMed,
              ),
              Gap.vertical(16),
              AppText(
                text: localize
                    .youCanCreateYourBudgetWithAIOrManuallyWhichOneDoYouPrefer,
                style: StyleType.bodMed,
                textAlign: TextAlign.center,
              ),
              Gap.vertical(24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onManualPressed,
                      child: AppText(
                        text: localize.manual,
                        style: StyleType.bodLg,
                      ),
                    ),
                  ),
                  Gap.horizontal(16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAiPressed,
                      child: AppText(
                        text: localize.generateWithAI,
                        style: StyleType.bodLg,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
