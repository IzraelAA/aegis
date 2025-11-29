import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:aegis_mobile/features/auth/domain/entities/auth_token_entity.dart';

/// Repository interface for authentication feature
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
  });

  /// Refresh access token using refresh token
  Future<Either<Failure, AuthTokenEntity>> refreshToken(String refreshToken);

  /// Get current user profile
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Logout and clear session
  Future<Either<Failure, bool>> logout();

  /// Check if user is logged in
  Future<Either<Failure, bool>> isLoggedIn();

  /// Get stored auth token
  Future<Either<Failure, AuthTokenEntity?>> getStoredToken();

  /// Auto login using stored credentials
  Future<Either<Failure, UserEntity>> autoLogin();
}

