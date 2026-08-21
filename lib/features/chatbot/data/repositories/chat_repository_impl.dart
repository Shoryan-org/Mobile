import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_response_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';
import '../models/chat_response_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    final List<dynamic> data = await _remoteDataSource.getChatHistory();
    return data.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  @override
  Future<ChatResponseEntity> sendChatMessage({
    required String message,
    String? sessionId,
  }) async {
    final Map<String, dynamic> data = await _remoteDataSource.sendChatMessage(message, sessionId);
    return ChatResponseModel.fromJson(data);
  }
}
