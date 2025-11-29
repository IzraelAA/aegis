import 'package:aegis_mobile/core/domain/entity/base_entity.dart';

/// Auth token entity containing access and refresh tokens
class AuthTokenEntity extends BaseEntity {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  AuthTokenEntity copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthTokenEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}

