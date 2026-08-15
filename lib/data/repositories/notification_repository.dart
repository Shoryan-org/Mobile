import '../../models/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications();

  /// Marks every notification as read. Returns the updated list so the
  /// screen can update its state in one round trip instead of re-fetching.
  Future<List<NotificationItem>> markAllAsRead();
}