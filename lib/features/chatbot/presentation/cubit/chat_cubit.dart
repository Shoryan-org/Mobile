import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetChatHistoryUseCase _getHistory;
  final SendChatMessageUseCase _sendMessage;
  
  String? _sessionId;
  List<ChatInteraction> _interactions = [];

  ChatCubit(this._getHistory, this._sendMessage) : super(ChatInitial());

  Future<void> loadHistory() async {
    emit(ChatLoadingHistory());
    try {
      final history = await _getHistory();
      
      _interactions = history.map((item) => ChatInteraction(
        message: item.message,
        answer: item.answer,
      )).toList();
      
      if (history.isNotEmpty) {
        _sessionId = history.last.sessionId;
      }
      
      emit(ChatHistoryLoaded(List.from(_interactions), _sessionId));
    } catch (e) {
      emit(ChatError(_extractMessage(e)));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message to UI immediately (answer is null -> loading indicator)
    _interactions.add(ChatInteraction(message: text));
    emit(ChatHistoryLoaded(List.from(_interactions), _sessionId));

    try {
      final response = await _sendMessage(message: text, sessionId: _sessionId);
      
      _sessionId = response.sessionId;
      
      // Update the last interaction with the AI's answer and sources
      final lastIndex = _interactions.length - 1;
      _interactions[lastIndex] = _interactions[lastIndex].copyWith(
        answer: response.answer,
        sources: response.sources,
      );
      
      emit(ChatHistoryLoaded(List.from(_interactions), _sessionId));
    } catch (e, stack) {
      debugPrint('ChatCubit sendMessage error: $e');
      debugPrint('Stack trace: $stack');
      // Mark as error
      final lastIndex = _interactions.length - 1;
      _interactions[lastIndex] = _interactions[lastIndex].copyWith(
        isError: true,
      );
      emit(ChatHistoryLoaded(List.from(_interactions), _sessionId));
      // Could also emit a temporary SnackBar error if needed, but in-place error is fine
    }
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return msg;
  }
}
