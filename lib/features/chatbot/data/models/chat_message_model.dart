import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.message,
    required super.answer,
    required super.sessionId,
    required super.sentAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int,
      message: json['message'] as String,
      answer: json['answer'] as String,
      sessionId: json['session_id'] as String,
      sentAt: json['sent_at'] as String,
    );
  }
}
