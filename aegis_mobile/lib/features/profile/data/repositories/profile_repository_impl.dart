import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:aegis_mobile/features/profile/data/models/profile_model.dart';
import 'package:aegis_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:aegis_mobile/features/profile/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
      ProfileEntity profile) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      final updated = await remoteDataSource.updateProfile(model);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> updateAvatar(String filePath) async {
    try {
      final url = await remoteDataSource.updateAvatar(filePath);
      return Right(url);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

