import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/notification_item.dart';
import '../common/icon_circle.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onRespond;

  const NotificationCard({super.key, required this.notification, this.onRespond});

  @override
  Widget build(BuildContext context) {
    final type = notification.type;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: type.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: type.cardBackground == AppColors.white
            ? Border.all(color: AppColors.border)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconCircle(
                icon: type.icon,
                background: type.iconBackground,
                iconColor: type.iconColor,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(notification.title, style: AppTextStyles.cardTitle),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(notification.timeAgo, style: AppTextStyles.metaText),
                  if (notification.isUnread && !notification.isActionable) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(notification.body, style: AppTextStyles.cardSubtitle),
          ),
          if (notification.isActionable) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 52),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: onRespond,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: const Text('Respond'),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Critical',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}