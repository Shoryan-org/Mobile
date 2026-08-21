import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chat_source_entity.dart';
import 'source_card.dart';

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String? text;
  final bool isError;
  final List<ChatSourceEntity> sources;

  const ChatBubble({
    super.key,
    required this.isUser,
    this.text,
    this.isError = false,
    this.sources = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 40.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              text ?? '',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    // AI Bubble
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.veryLightPink,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: AppColors.primaryRed,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5), // 0.02 * 255 ≈ 5
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isError
                  ? Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.primaryRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Failed to load response.',
                            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primaryRed),
                          ),
                        ),
                      ],
                    )
                  : (text == null)
                      ? const Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Rafik is typing...',
                              style: AppTextStyles.cardSubtitle,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MarkdownBody(
                              data: text!,
                              styleSheet: MarkdownStyleSheet(
                                p: AppTextStyles.cardTitle.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                                strong: AppTextStyles.cardTitle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (sources.isNotEmpty)
                              ...sources.map((source) => SourceCard(
                                    title: source.section,
                                    text: _truncate(source.docTitle), // Just displaying a snippet based on UI
                                  )),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  String _truncate(String text) {
    if (text.length > 60) return '${text.substring(0, 60)}...';
    return text;
  }
}
