import '../../models/notification_item.dart';
import '../../models/notification_type.dart';
import 'notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  static final List<NotificationItem> _notifications = [
    const NotificationItem(
      id: 'n1',
      type: NotificationType.criticalRequest,
      title: 'Critical O- request 1.2 km away',
      body: 'Al Nahda General Hospital needs 3 units within the next hour.',
      timeAgo: '6 min',
      isUnread: true,
      isActionable: true,
    ),
    const NotificationItem(
      id: 'n2',
      type: NotificationType.requestAccepted,
      title: 'Karim accepted your request',
      body: 'He is on the way to Dar El Shefa Medical Center.',
      timeAgo: '38 min',
      isUnread: true,
    ),
    const NotificationItem(
      id: 'n3',
      type: NotificationType.eligibilityReminder,
      title: "You're eligible to donate again",
      body: 'Your 90-day recovery window has ended. You can donate today.',
      timeAgo: '2 hrs',
    ),
    const NotificationItem(
      id: 'n4',
      type: NotificationType.requestFulfilled,
      title: 'Request #RQ-2481 fulfilled',
      body: 'All 2 units were collected. Thank you for sharing it.',
      timeAgo: 'Yesterday',
    ),
    const NotificationItem(
      id: 'n5',
      type: NotificationType.nearbyRequest,
      title: 'New A+ request nearby',
      body: 'Heliopolis · 2.8 km from your saved location.',
      timeAgo: 'Yesterday',
    ),
  ];

  @override
  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_notifications);
  }

  @override
  Future<List<NotificationItem>> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isUnread: false);
    }
    return List.unmodifiable(_notifications);
  }
}