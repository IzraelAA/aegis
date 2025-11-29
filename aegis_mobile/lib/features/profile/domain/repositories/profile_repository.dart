import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/profile/domain/entities/profile_entity.dart';

/// Repository interface for profile feature
abstract class ProfileRepository {
  /// Get current user profile
  Future<Either<Failure, ProfileEntity>> getProfile();

  /// Update user profile
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);

  /// Update avatar
  Future<Either<Failure, String>> updateAvatar(String filePath);

  /// Change password
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

