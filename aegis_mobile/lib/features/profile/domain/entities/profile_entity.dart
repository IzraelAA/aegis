import 'package:aegis_mobile/core/domain/entity/base_entity.dart';

/// Profile entity representing user profile
class ProfileEntity extends BaseEntity {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final String? role;
  final String? department;
  final String? employeeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.role,
    this.department,
    this.employeeId,
    this.createdAt,
    this.updatedAt,
  });

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    String? role,
    String? department,
    String? employeeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      employeeId: employeeId ?? this.employeeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        phone,
        role,
        department,
        employeeId,
        createdAt,
        updatedAt,
      ];
}

