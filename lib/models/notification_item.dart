import 'notification_type.dart';

/// A single row on the Notifications screen.
class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String timeAgo;
  final bool isUnread;
  final bool isActionable;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.isUnread = false,
    this.isActionable = false,
  });

  NotificationItem copyWith({bool? isUnread}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      timeAgo: timeAgo,
      isUnread: isUnread ?? this.isUnread,
      isActionable: isActionable,
    );
  }
}