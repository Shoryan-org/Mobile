import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/mock_notification_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../models/notification_item.dart';
import '../../widgets/notifications/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  final NotificationRepository repository;

  NotificationsScreen({super.key, NotificationRepository? repository})
      : repository = repository ?? MockNotificationRepository();

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final notifications = await widget.repository.getNotifications();
    if (!mounted) return;
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  Future<void> _markAllRead() async {
    final notifications = await widget.repository.markAllAsRead();
    if (!mounted) return;
    setState(() => _notifications = notifications);
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: _unreadCount > 0 ? _markAllRead : null,
              child: const Text('Mark all read'),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed))
          : ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(
            _unreadCount > 0 ? '$_unreadCount unread' : 'All caught up',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ..._notifications.map(
                (notification) => NotificationCard(
              notification: notification,
              onRespond: () {},
            ),
          ),
        ],
      ),
    );
  }
}