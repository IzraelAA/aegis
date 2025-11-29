import 'package:aegis_mobile/core/data/model/base_model.dart';
import 'package:aegis_mobile/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends BaseModel<ProfileEntity> {
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

  ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      department: json['department'] as String?,
      employeeId: json['employee_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar,
      phone: entity.phone,
      role: entity.role,
      department: entity.department,
      employeeId: entity.employeeId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'role': role,
      'department': department,
      'employee_id': employeeId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      phone: phone,
      role: role,
      department: department,
      employeeId: employeeId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

