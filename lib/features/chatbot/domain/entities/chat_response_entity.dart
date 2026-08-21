import 'chat_source_entity.dart';

class ChatResponseEntity {
  final String answer;
  final String sessionId;
  final List<ChatSourceEntity> sources;

  const ChatResponseEntity({
    required this.answer,
    required this.sessionId,
    required this.sources,
  });
}
