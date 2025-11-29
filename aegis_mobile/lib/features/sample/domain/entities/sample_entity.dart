import 'package:aegis_mobile/core/domain/entity/base_entity.dart';

/// Sample entity representing a user
class SampleEntity extends BaseEntity {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;

  const SampleEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
  });

  SampleEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? createdAt,
  }) {
    return SampleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatar, createdAt];
}

