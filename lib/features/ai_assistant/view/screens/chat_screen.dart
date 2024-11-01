import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/ai_assistant/ai_assistant_barrel.dart';
import 'package:budget_intelli/features/ai_assistant/view/controller/chat/chat_cubit.dart';
import 'package:budget_intelli/features/google_generative_ai/data/datasources/db/sqflite_db.dart';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  List<List<Message>> messagesGroupByChatId = [];
  final String chatId = const Uuid().v1();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final _promptController = TextEditingController();
  final _focusNode = FocusNode();

  // Future<void> getMessages() async {
  //   final messages = await _databaseHelper.getMessages();

  //   final getMessagesGroupByChatId =
  //       await _databaseHelper.getMessagesGroupByChatId();

  //   setState(() {
  //     this.messages = messages;
  //     messagesGroupByChatId = getMessagesGroupByChatId!;
  //   });
  // }

  // Future<void> insertMessage(Message message) async {
  //   await _databaseHelper.insertMessage(message);
  //   getMessages();
  // }

  @override
  void initState() {
    super.initState();
    _databaseHelper.initDatabase();
    _initGemini();
    // getMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _promptController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // void _scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_scrollController.hasClients &&
  //         _scrollController.position.maxScrollExtent > 0.0) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  void _initGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey != null) {
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
      );

      _chat = _model.startChat();
      setState(() {});
    } else {
      throw Exception('API key not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimary(
        context: context,
        title: 'Chat With Ai',
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final messages = state.generatedMessages;
          return Column(
            children: [
              Expanded(
                child: ChatMessages(
                  scrollController: _scrollController,
                  messages: messages,
                ),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  boxShadow: [
                    // add shadow on the top side
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                      blurRadius: 10, // soften the shadow
                      offset: const Offset(
                        0, // Move to right 10  horizontally
                        -10, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _promptController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Enter a prompt',
                            border: InputBorder.none,
                            hintStyle: textStyle(
                              context,
                              StyleType.bodLg,
                            ).copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onSubmitted: (value) {
                            context.read<ChatCubit>().sendChatMessage(
                                  prompt: _promptController.text,
                                  chatId: chatId,
                                  chatSession: _chat,
                                  previousList: messages,
                                );

                            _promptController.clear();

                            _focusNode.unfocus();
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<ChatCubit>().sendChatMessage(
                                prompt: _promptController.text,
                                chatId: chatId,
                                chatSession: _chat,
                                previousList: messages,
                              );
                          _promptController.clear();

                          _focusNode.unfocus();
                        },
                        icon: getSvgPicture(
                          send,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      endDrawer: DrawerWidget(
        messagesGroupByChatId: messagesGroupByChatId,
      ),
    );
  }
}
