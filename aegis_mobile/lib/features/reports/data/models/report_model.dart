import 'package:aegis_mobile/core/data/model/base_model.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';

class ReportModel extends BaseModel<ReportEntity> {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String status;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final List<String> photoUrls;
  final String? reporterId;
  final String? reporterName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isOffline;

  ReportModel({
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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      severity: json['severity'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationName: json['location_name'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      reporterId: json['reporter_id']?.toString(),
      reporterName: json['reporter_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      isOffline: json['is_offline'] as bool? ?? false,
    );
  }

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      severity: entity.severity.name,
      status: entity.status.name,
      latitude: entity.latitude,
      longitude: entity.longitude,
      locationName: entity.locationName,
      photoUrls: entity.photoUrls,
      reporterId: entity.reporterId,
      reporterName: entity.reporterName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isOffline: entity.isOffline,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'photo_urls': photoUrls,
      'reporter_id': reporterId,
      'reporter_name': reporterName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_offline': isOffline,
    };
  }

  @override
  ReportEntity toEntity() {
    return ReportEntity(
      id: id,
      title: title,
      description: description,
      severity: _parseSeverity(severity),
      status: _parseStatus(status),
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      photoUrls: photoUrls,
      reporterId: reporterId,
      reporterName: reporterName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isOffline: isOffline,
    );
  }

  ReportSeverity _parseSeverity(String severity) {
    return ReportSeverity.values.firstWhere(
      (e) => e.name == severity.toLowerCase(),
      orElse: () => ReportSeverity.medium,
    );
  }

  ReportStatus _parseStatus(String status) {
    return ReportStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => ReportStatus.pending,
    );
  }
}

