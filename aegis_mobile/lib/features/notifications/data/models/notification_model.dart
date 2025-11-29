import 'package:aegis_mobile/core/data/model/base_model.dart';
import 'package:aegis_mobile/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends BaseModel<NotificationEntity> {
  final String id;
  final String title;
  final String body;
  final String type;
  final String priority;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.priority = 'normal',
    this.data,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'info',
      priority: json['priority'] as String? ?? 'normal',
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? json['read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'] as String)
          : null,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type.name,
      priority: entity.priority.name,
      data: entity.data,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
      readAt: entity.readAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'priority': priority,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  @override
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      type: _parseType(type),
      priority: _parsePriority(priority),
      data: data,
      isRead: isRead,
      createdAt: createdAt,
      readAt: readAt,
    );
  }

  NotificationType _parseType(String type) {
    return NotificationType.values.firstWhere(
      (e) => e.name == type.toLowerCase(),
      orElse: () => NotificationType.info,
    );
  }

  NotificationPriority _parsePriority(String priority) {
    return NotificationPriority.values.firstWhere(
      (e) => e.name == priority.toLowerCase(),
      orElse: () => NotificationPriority.normal,
    );
  }
}

