import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/notifications/domain/entities/notification_entity.dart';

/// Repository interface for notifications feature
abstract class NotificationRepository {
  /// Get all notifications
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// Mark notification as read
  Future<Either<Failure, bool>> markAsRead(String id);

  /// Mark all notifications as read
  Future<Either<Failure, bool>> markAllAsRead();

  /// Delete notification
  Future<Either<Failure, bool>> deleteNotification(String id);

  /// Get unread count
  Future<Either<Failure, int>> getUnreadCount();

  /// Subscribe to push notifications
  Future<Either<Failure, bool>> subscribeToPushNotifications(String token);

  /// Unsubscribe from push notifications
  Future<Either<Failure, bool>> unsubscribeFromPushNotifications();
}

