import 'package:aegis_mobile/core/domain/entity/base_entity.dart';

/// User entity representing authenticated user
class UserEntity extends BaseEntity {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final String? role;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.role,
    this.createdAt,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    String? role,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatar, phone, role, createdAt];
}

