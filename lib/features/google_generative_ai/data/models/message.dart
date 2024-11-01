import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  Message({
    required this.text,
    required this.role,
    required this.messageIndex,
    required this.chatId,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  final String text;
  final String role;
  final int messageIndex;
  final String chatId;

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
