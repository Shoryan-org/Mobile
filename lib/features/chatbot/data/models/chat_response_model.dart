import '../../domain/entities/chat_response_entity.dart';
import 'chat_source_model.dart';

class ChatResponseModel extends ChatResponseEntity {
  const ChatResponseModel({
    required super.answer,
    required super.sessionId,
    required super.sources,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    var sourcesList = json['sources'] as List? ?? [];
    List<ChatSourceModel> parsedSources = sourcesList
        .map((sourceJson) => ChatSourceModel.fromJson(sourceJson))
        .toList();

    return ChatResponseModel(
      answer: json['answer'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
      sources: parsedSources,
    );
  }
}
