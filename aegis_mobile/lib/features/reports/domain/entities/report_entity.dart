import 'package:aegis_mobile/core/domain/entity/base_entity.dart';

enum ReportSeverity { low, medium, high, critical }

enum ReportStatus { draft, pending, submitted, reviewed, resolved }

/// Report entity representing an incident report
class ReportEntity extends BaseEntity {
  final String id;
  final String title;
  final String description;
  final ReportSeverity severity;
  final ReportStatus status;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final List<String> photoUrls;
  final String? reporterId;
  final String? reporterName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isOffline;

  const ReportEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    this.latitude,
    this.longitude,
    this.locationName,
    this.photoUrls = const [],
    this.reporterId,
    this.reporterName,
    required this.createdAt,
    this.updatedAt,
    this.isOffline = false,
  });

  ReportEntity copyWith({
    String? id,
    String? title,
    String? description,
    ReportSeverity? severity,
    ReportStatus? status,
    double? latitude,
    double? longitude,
    String? locationName,
    List<String>? photoUrls,
    String? reporterId,
    String? reporterName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOffline,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      photoUrls: photoUrls ?? this.photoUrls,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        severity,
        status,
        latitude,
        longitude,
        locationName,
        photoUrls,
        reporterId,
        reporterName,
        createdAt,
        updatedAt,
        isOffline,
      ];
}

