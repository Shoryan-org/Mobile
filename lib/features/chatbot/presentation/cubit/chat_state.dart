import 'package:flutter/foundation.dart';
import '../../domain/entities/chat_source_entity.dart';

class ChatInteraction {
  final String message; // User message
  final String? answer; // AI answer (null if loading)
  final List<ChatSourceEntity> sources;
  final bool isError;

  const ChatInteraction({
    required this.message,
    this.answer,
    this.sources = const [],
    this.isError = false,
  });

  ChatInteraction copyWith({
    String? message,
    String? answer,
    List<ChatSourceEntity>? sources,
    bool? isError,
  }) {
    return ChatInteraction(
      message: message ?? this.message,
      answer: answer ?? this.answer,
      sources: sources ?? this.sources,
      isError: isError ?? this.isError,
    );
  }
}

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoadingHistory extends ChatState {}

class ChatHistoryLoaded extends ChatState {
  final List<ChatInteraction> interactions;
  final String? sessionId;

  ChatHistoryLoaded(this.interactions, this.sessionId);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
