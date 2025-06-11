import 'dart:async';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/google_generative_ai/data/datasources/db/sqflite_db.dart';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState(generatedMessages: []));

  Future<void> sendChatMessage({
    required String prompt,
    required String chatId,
    required ChatSession chatSession,
    required List<Message> previousList,
  }) async {
    try {
      /// User Send the message to the chat
      final message = Message(
        chatId: chatId,
        text: prompt,
        role: AppStrings.user,
        messageIndex: state.generatedMessages.length + 1,
      );

      emit(
        state.copyWith(
          generatedMessages: [...previousList, message],
          loading: true,
        ),
      );

      await insertMessageToDB(message);

      /// AI Generate the response
      final response = await chatSession.sendMessage(Content.text(prompt));

      final generatedMessage = Message(
        chatId: chatId,
        text: response.text!,
        role: AppStrings.model,
        messageIndex: state.generatedMessages.length + 1,
      );
      emit(
        state.copyWith(
          generatedMessages: [...state.generatedMessages, generatedMessage],
          loading: false,
        ),
      );
      await insertMessageToDB(generatedMessage);
    } on Exception catch (e) {
      emit(
        state.copyWith(
          messageError: e.toString(),
        ),
      );
    }
  }

  Future<void> insertMessageToDB(Message message) async {
    final db = await DatabaseHelper().database;
    await db.insert('messages', message.toJson());
  }
}
