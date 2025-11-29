import 'package:aegis_mobile/core/data/model/base_model.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';

class ChecklistItemModel extends BaseModel<ChecklistItemEntity> {
  final String id;
  final String question;
  final bool? isCompliant;
  final String? notes;
  final List<String> photoUrls;

  ChecklistItemModel({
    required this.id,
    required this.question,
    this.isCompliant,
    this.notes,
    this.photoUrls = const [],
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id']?.toString() ?? '',
      question: json['question'] as String? ?? '',
      isCompliant: json['is_compliant'] as bool?,
      notes: json['notes'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  factory ChecklistItemModel.fromEntity(ChecklistItemEntity entity) {
    return ChecklistItemModel(
      id: entity.id,
      question: entity.question,
      isCompliant: entity.isCompliant,
      notes: entity.notes,
      photoUrls: entity.photoUrls,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'is_compliant': isCompliant,
      'notes': notes,
      'photo_urls': photoUrls,
    };
  }

  @override
  ChecklistItemEntity toEntity() {
    return ChecklistItemEntity(
      id: id,
      question: question,
      isCompliant: isCompliant,
      notes: notes,
      photoUrls: photoUrls,
    );
  }
}

class InspectionModel extends BaseModel<InspectionEntity> {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String status;
  final List<ChecklistItemModel> checklistItems;
  final String? inspectorId;
  final String? inspectorName;
  final String? location;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? signature;
  final String? notes;

  InspectionModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    this.checklistItems = const [],
    this.inspectorId,
    this.inspectorName,
    this.location,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.completedAt,
    this.signature,
    this.notes,
  });

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'general',
      status: json['status'] as String? ?? 'pending',
      checklistItems: (json['checklist_items'] as List<dynamic>?)
              ?.map((e) =>
                  ChecklistItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      inspectorId: json['inspector_id']?.toString(),
      inspectorName: json['inspector_name'] as String?,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      signature: json['signature'] as String?,
      notes: json['notes'] as String?,
    );
  }

  factory InspectionModel.fromEntity(InspectionEntity entity) {
    return InspectionModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      status: entity.status.name,
      checklistItems: entity.checklistItems
          .map((e) => ChecklistItemModel.fromEntity(e))
          .toList(),
      inspectorId: entity.inspectorId,
      inspectorName: entity.inspectorName,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      signature: entity.signature,
      notes: entity.notes,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'checklist_items': checklistItems.map((e) => e.toJson()).toList(),
      'inspector_id': inspectorId,
      'inspector_name': inspectorName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'signature': signature,
      'notes': notes,
    };
  }

  @override
  InspectionEntity toEntity() {
    return InspectionEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      status: _parseStatus(status),
      checklistItems: checklistItems.map((e) => e.toEntity()).toList(),
      inspectorId: inspectorId,
      inspectorName: inspectorName,
      location: location,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      completedAt: completedAt,
      signature: signature,
      notes: notes,
    );
  }

  InspectionStatus _parseStatus(String status) {
    return InspectionStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => InspectionStatus.pending,
    );
  }
}

