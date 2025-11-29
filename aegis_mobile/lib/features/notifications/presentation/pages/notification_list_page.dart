import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/state_management/base_state.dart';
import 'package:aegis_mobile/features/notifications/domain/entities/notification_entity.dart';
import 'package:aegis_mobile/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:aegis_mobile/utils/app_color.dart';
import 'package:aegis_mobile/utils/app_typography.dart';
import 'package:aegis_mobile/utils/widgets/app_loading.dart';

@RoutePage()
class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>()..loadNotifications(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () {
                // TODO: Mark all as read
              },
              tooltip: 'Mark all as read',
            ),
          ],
        ),
        body: BlocBuilder<NotificationCubit, BaseState<List<NotificationEntity>>>(
          builder: (context, state) {
            if (state.isLoading) {
              return const AppLoading();
            }

            if (state.isError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColor.error),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Failed to load notifications',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<NotificationCubit>().loadNotifications(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none,
                        size: 64, color: AppColor.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            final notifications = state.data ?? [];
            return RefreshIndicator(
              onRefresh: () => context.read<NotificationCubit>().refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _NotificationCard(
                    notification: notification,
                    onTap: () {
                      context.read<NotificationCubit>().markAsRead(notification.id);
                      // TODO: Navigate based on notification type/data
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: notification.isRead
          ? null
          : AppColor.primary.withValues(alpha: 0.05),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(notification.type).withValues(alpha: 0.2),
          child: Icon(
            _getTypeIcon(notification.type),
            color: _getTypeColor(notification.type),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: notification.isRead
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.body,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(notification.createdAt),
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.alert:
        return AppColor.error;
      case NotificationType.warning:
        return AppColor.warning;
      case NotificationType.success:
        return AppColor.success;
      case NotificationType.info:
        return AppColor.info;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.alert:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.info:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

