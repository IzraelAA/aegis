import 'package:aegis_mobile/core/domain/entity/base_entity.dart';

enum InspectionStatus { pending, inProgress, completed, failed }

/// Checklist item for inspection
class ChecklistItemEntity extends BaseEntity {
  final String id;
  final String question;
  final bool? isCompliant;
  final String? notes;
  final List<String> photoUrls;

  const ChecklistItemEntity({
    required this.id,
    required this.question,
    this.isCompliant,
    this.notes,
    this.photoUrls = const [],
  });

  ChecklistItemEntity copyWith({
    String? id,
    String? question,
    bool? isCompliant,
    String? notes,
    List<String>? photoUrls,
  }) {
    return ChecklistItemEntity(
      id: id ?? this.id,
      question: question ?? this.question,
      isCompliant: isCompliant ?? this.isCompliant,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
    );
  }

  @override
  List<Object?> get props => [id, question, isCompliant, notes, photoUrls];
}

/// Inspection entity representing a safety inspection
class InspectionEntity extends BaseEntity {
  final String id;
  final String title;
  final String? description;
  final String category;
  final InspectionStatus status;
  final List<ChecklistItemEntity> checklistItems;
  final String? inspectorId;
  final String? inspectorName;
  final String? location;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? signature;
  final String? notes;

  const InspectionEntity({
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

  InspectionEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    InspectionStatus? status,
    List<ChecklistItemEntity>? checklistItems,
    String? inspectorId,
    String? inspectorName,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? completedAt,
    String? signature,
    String? notes,
  }) {
    return InspectionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      checklistItems: checklistItems ?? this.checklistItems,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectorName: inspectorName ?? this.inspectorName,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      signature: signature ?? this.signature,
      notes: notes ?? this.notes,
    );
  }

  int get totalItems => checklistItems.length;
  int get completedItems =>
      checklistItems.where((item) => item.isCompliant != null).length;
  int get compliantItems =>
      checklistItems.where((item) => item.isCompliant == true).length;
  int get nonCompliantItems =>
      checklistItems.where((item) => item.isCompliant == false).length;

  double get completionPercentage =>
      totalItems > 0 ? (completedItems / totalItems) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        status,
        checklistItems,
        inspectorId,
        inspectorName,
        location,
        latitude,
        longitude,
        createdAt,
        completedAt,
        signature,
        notes,
      ];
}

