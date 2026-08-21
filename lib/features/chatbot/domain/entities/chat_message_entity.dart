class ChatMessageEntity {
  final int id;
  final String message;
  final String answer;
  final String sessionId;
  final String sentAt;

  const ChatMessageEntity({
    required this.id,
    required this.message,
    required this.answer,
    required this.sessionId,
    required this.sentAt,
  });
}
