import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: getEdgeInsetsSymmetric(vertical: 8),
        child: CustomPaint(
          painter: BubblePainter(
            tail: true,
            alignment: Alignment.topLeft,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: getEdgeInsets(
              top: 10,
              right: 10,
              left: 15,
              bottom: 10,
            ),
            // margin: const EdgeInsets.only(bottom: 8),
            child: message.text.isEmpty
                ? const SizedBox(
                    width: 50,
                    child: CircularProgressIndicator(),
                  )
                : MarkdownBody(
                    selectable: true,
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: textStyle(
                        context,
                        StyleType.bodMd,
                      ).copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
