import 'package:aegis_mobile/core/data/model/base_model.dart';
import 'package:aegis_mobile/features/sample/domain/entities/sample_entity.dart';

class SampleModel extends BaseModel<SampleEntity> {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;

  SampleModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
  });

  factory SampleModel.fromJson(Map<String, dynamic> json) {
    return SampleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  factory SampleModel.fromEntity(SampleEntity entity) {
    return SampleModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      createdAt: entity.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  SampleEntity toEntity() {
    return SampleEntity(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      createdAt: createdAt,
    );
  }
}

