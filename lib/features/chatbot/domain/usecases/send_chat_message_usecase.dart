import '../entities/chat_response_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase(this.repository);

  Future<ChatResponseEntity> call({
    required String message,
    String? sessionId,
  }) async {
    return await repository.sendChatMessage(
      message: message,
      sessionId: sessionId,
    );
  }
}
