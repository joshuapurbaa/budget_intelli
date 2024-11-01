// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      text: json['text'] as String,
      role: json['role'] as String,
      messageIndex: json['messageIndex'] as int,
      chatId: json['chatId'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'text': instance.text,
      'role': instance.role,
      'messageIndex': instance.messageIndex,
      'chatId': instance.chatId,
    };
