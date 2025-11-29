import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/notifications/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<bool> markAsRead(String id);
  Future<bool> markAllAsRead();
  Future<bool> deleteNotification(String id);
  Future<int> getUnreadCount();
  Future<bool> registerDeviceToken(String token);
  Future<bool> unregisterDeviceToken();
}

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl extends BaseRemoteDataSource
    implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(super.dio);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.notifications);
      return extractListData<NotificationModel>(
        response,
        (json) => NotificationModel.fromJson(json),
      );
    });
  }

  @override
  Future<bool> markAsRead(String id) async {
    return safeApiCall(() async {
      await dio.put('${ApiEndpoints.notifications}/$id/read');
      return true;
    });
  }

  @override
  Future<bool> markAllAsRead() async {
    return safeApiCall(() async {
      await dio.put('${ApiEndpoints.notifications}/read-all');
      return true;
    });
  }

  @override
  Future<bool> deleteNotification(String id) async {
    return safeApiCall(() async {
      await dio.delete('${ApiEndpoints.notifications}/$id');
      return true;
    });
  }

  @override
  Future<int> getUnreadCount() async {
    return safeApiCall(() async {
      final response = await dio.get('${ApiEndpoints.notifications}/unread-count');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['count'] as int? ?? data['data']['count'] as int? ?? 0;
      }
      return 0;
    });
  }

  @override
  Future<bool> registerDeviceToken(String token) async {
    return safeApiCall(() async {
      await dio.post(
        ApiEndpoints.deviceToken,
        data: {'token': token, 'platform': 'mobile'},
      );
      return true;
    });
  }

  @override
  Future<bool> unregisterDeviceToken() async {
    return safeApiCall(() async {
      await dio.delete(ApiEndpoints.deviceToken);
      return true;
    });
  }
}

