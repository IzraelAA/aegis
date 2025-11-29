import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:aegis_mobile/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:aegis_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:aegis_mobile/features/notifications/domain/repositories/notification_repository.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      // Try cached data first
      if (localDataSource.hasCachedNotifications()) {
        final cached = await localDataSource.getCachedNotifications();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      }

      // Fetch from remote
      final remote = await remoteDataSource.getNotifications();
      await localDataSource.cacheNotifications(remote);
      return Right(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      // Fallback to cached data
      try {
        final cached = await localDataSource.getCachedNotifications();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead(String id) async {
    try {
      await remoteDataSource.markAsRead(id);
      await localDataSource.clearNotificationCache();
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      await localDataSource.clearNotificationCache();
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(String id) async {
    try {
      await remoteDataSource.deleteNotification(id);
      await localDataSource.clearNotificationCache();
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> subscribeToPushNotifications(String token) async {
    try {
      await remoteDataSource.registerDeviceToken(token);
      await localDataSource.saveDeviceToken(token);
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> unsubscribeFromPushNotifications() async {
    try {
      await remoteDataSource.unregisterDeviceToken();
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

