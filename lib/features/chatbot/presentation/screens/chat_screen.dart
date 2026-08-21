import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_area.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _suggestedPrompts = [
    'Can I donate if I have a cold?',
    'Iron level requirements for donation',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100, // Extra offset for new messages
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.offWhite,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/placeholder_avatar.png'), // Using a placeholder or generic icon if avatar not found
              backgroundColor: AppColors.veryLightPink,
              child: Icon(Icons.person, color: AppColors.primaryRed, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Rafik',
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.primaryRed,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatHistoryLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoadingHistory) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChatInteraction> interactions = [];
          if (state is ChatHistoryLoaded) {
            interactions = state.interactions;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  itemCount: interactions.length + 2, // +1 for date separator, +1 for initial greeting
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 24.0),
                          child: Chip(
                            label: Text('TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1.2)),
                            backgroundColor: AppColors.veryLightPink,
                            side: BorderSide.none,
                          ),
                        ),
                      );
                    }
                    if (index == 1) {
                      return const ChatBubble(
                        isUser: false,
                        text: 'Hello. I am the Rafik AI Assistant. I can help answer questions about donation eligibility, preparation, or guide you to the nearest clinic. How can I assist you today?',
                      );
                    }

                    final interaction = interactions[index - 2];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ChatBubble(
                          isUser: true,
                          text: interaction.message,
                        ),
                        ChatBubble(
                          isUser: false,
                          text: interaction.answer,
                          sources: interaction.sources,
                          isError: interaction.isError,
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Suggested Prompts
              if (interactions.isEmpty || interactions.last.answer != null)
                Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestedPrompts.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ActionChip(
                        label: Text(
                          _suggestedPrompts[index],
                          style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w500),
                        ),
                        backgroundColor: AppColors.white,
                        side: BorderSide(color: AppColors.primaryRed.withAlpha(51)), // 0.2 * 255 = 51
                        onPressed: () {
                          context.read<ChatCubit>().sendMessage(_suggestedPrompts[index]);
                        },
                      );
                    },
                  ),
                ),
              ChatInputArea(
                onSend: (text) {
                  context.read<ChatCubit>().sendMessage(text);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
