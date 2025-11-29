import 'package:aegis_mobile/core/data/model/base_model.dart';
import 'package:aegis_mobile/features/auth/domain/entities/auth_token_entity.dart';

class AuthTokenModel extends BaseModel<AuthTokenEntity> {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    DateTime? expiresAt;
    if (json['expires_at'] != null) {
      expiresAt = DateTime.tryParse(json['expires_at'] as String);
    } else if (json['expires_in'] != null) {
      final expiresIn = json['expires_in'] as int;
      expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    }

    return AuthTokenModel(
      accessToken: json['access_token'] as String? ?? json['token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expiresAt: expiresAt,
    );
  }

  factory AuthTokenModel.fromEntity(AuthTokenEntity entity) {
    return AuthTokenModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  @override
  AuthTokenEntity toEntity() {
    return AuthTokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}

