import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/urgency_level.dart';

class UrgencyBadge extends StatelessWidget {
  final UrgencyLevel urgency;

  const UrgencyBadge({super.key, required this.urgency});

  @override
  Widget build(BuildContext context) {
    final bool showDot = urgency == UrgencyLevel.critical;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: urgency.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: urgency.foreground,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            urgency.label,
            style: AppTextStyles.badgeText.copyWith(color: urgency.foreground),
          ),
        ],
      ),
    );
  }
}