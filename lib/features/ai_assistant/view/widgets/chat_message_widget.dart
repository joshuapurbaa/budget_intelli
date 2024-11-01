import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    required this.scrollController,
    required this.messages,
    super.key,
  });

  final ScrollController scrollController;
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: AppText.color(
          text: 'Start ',
          style: StyleType.headSm,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return ListView.builder(
      padding: getEdgeInsets(
        top: 16,
        right: 12,
        left: 12,
        bottom: 20,
      ),
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final user = messages[index].role == AppStrings.user;

        return user
            ? MyMessageWidget(
                message: messages[index],
              )
            : AssistantMessageWidget(
                message: messages[index],
              );
      },
    );
  }
}
