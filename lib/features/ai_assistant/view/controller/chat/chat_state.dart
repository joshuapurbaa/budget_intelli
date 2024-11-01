part of 'chat_cubit.dart';

final class ChatState {
  const ChatState({
    required this.generatedMessages,
    this.loading = false,
    this.messageError = '',
  });

  final List<Message> generatedMessages;
  final bool loading;
  final String messageError;

  ChatState copyWith({
    List<Message>? generatedMessages,
    bool? loading,
    String? messageError,
  }) {
    return ChatState(
      generatedMessages: generatedMessages ?? this.generatedMessages,
      loading: loading ?? this.loading,
      messageError: messageError ?? this.messageError,
    );
  }
}
