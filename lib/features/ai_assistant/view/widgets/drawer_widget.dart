import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    required this.messagesGroupByChatId,
    super.key,
  });
  final List<List<Message>> messagesGroupByChatId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(
          top: 40,
          right: 16,
          left: 16,
        ),
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close),
            ),
          ),
          Gap.vertical(20),
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.tertiaryContainer,
              ),
              iconColor: WidgetStateProperty.all(
                AppColor.white,
              ),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.add,
            ),
            label: const AppText(
              text: 'Create New Chat',
              style: StyleType.bodMed,
            ),
          ),
          // Gap.vertical(16),
          // AppText.medium16(
          //   text: 'Recent',
          // ),
          Gap.vertical(16),
          AppText.color(
            text: 'Today',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            style: StyleType.bodMed,
          ),
          Gap.vertical(16),
          ...messagesGroupByChatId.map(
            (messages) {
              final lastMessage = messages.last.text;
              return ListTile(
                onTap: () {
                  // context.push(
                  //   RouteName.chatScreen,
                  //   arguments: chatId,
                  // );
                },
                title: AppText(
                  text: lastMessage,
                  style: StyleType.bodMed,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
