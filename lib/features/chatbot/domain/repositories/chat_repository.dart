import '../entities/chat_message_entity.dart';
import '../entities/chat_response_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> getChatHistory();
  Future<ChatResponseEntity> sendChatMessage({
    required String message,
    String? sessionId,
  });
}
