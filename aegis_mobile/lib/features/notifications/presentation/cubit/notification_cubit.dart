import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/state_management/base_cubit.dart';
import 'package:aegis_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:aegis_mobile/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:aegis_mobile/features/notifications/domain/usecases/mark_notification_read_usecase.dart';

@injectable
class NotificationCubit extends BaseCubit<List<NotificationEntity>> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  });

  Future<void> loadNotifications() async {
    emitLoading();

    final result = await getNotificationsUseCase(const NoParams());

    result.fold(
      (failure) => emitError(failure.message),
      (notifications) {
        if (notifications.isEmpty) {
          emitEmpty();
        } else {
          emitSuccess(notifications);
        }
      },
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await markNotificationReadUseCase(IdParams(id: id));

    result.fold(
      (failure) => {/* Silently fail */},
      (_) => loadNotifications(),
    );
  }

  Future<void> refresh() async {
    await loadNotifications();
  }

  int get unreadCount {
    final notifications = state.data ?? [];
    return notifications.where((n) => !n.isRead).length;
  }
}

