import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_local_datasource.dart';
import 'package:aegis_mobile/features/notifications/data/models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getCachedNotifications();
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  bool hasCachedNotifications();
  Future<void> clearNotificationCache();
  Future<void> saveDeviceToken(String token);
  String? getDeviceToken();
}

@LazySingleton(as: NotificationLocalDataSource)
class NotificationLocalDataSourceImpl extends BaseLocalDataSource
    implements NotificationLocalDataSource {
  static const String _notificationsKey = 'cached_notifications';
  static const String _timestampKey = 'notifications_timestamp';
  static const String _deviceTokenKey = 'device_token';
  static const Duration _cacheMaxAge = Duration(minutes: 15);

  NotificationLocalDataSourceImpl(super.storage);

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    return safeCacheCall(() async {
      final jsonString = storage.get<String>(_notificationsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    return safeCacheCall(() async {
      final jsonList = notifications.map((n) => n.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await saveWithTimestamp(_notificationsKey, jsonString, _timestampKey);
    });
  }

  @override
  bool hasCachedNotifications() {
    return isCacheValid(_timestampKey, _cacheMaxAge);
  }

  @override
  Future<void> clearNotificationCache() async {
    await clearCache(_notificationsKey, _timestampKey);
  }

  @override
  Future<void> saveDeviceToken(String token) async {
    await storage.put(_deviceTokenKey, token);
  }

  @override
  String? getDeviceToken() {
    return storage.get<String>(_deviceTokenKey);
  }
}

