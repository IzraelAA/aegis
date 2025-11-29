import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:aegis_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:aegis_mobile/features/auth/domain/entities/auth_token_entity.dart';
import 'package:aegis_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:aegis_mobile/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokenModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      
      // Cache token locally
      await localDataSource.cacheToken(tokenModel);
      
      return Right(tokenModel.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity>> refreshToken(String refreshToken) async {
    try {
      final tokenModel = await remoteDataSource.refreshToken(refreshToken);
      
      // Cache new token
      await localDataSource.cacheToken(tokenModel);
      
      return Right(tokenModel.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      
      // Cache user locally
      await localDataSource.cacheUser(userModel);
      
      return Right(userModel.toEntity());
    } catch (e) {
      // Try to get cached user if remote fails
      final cachedUser = localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearSession();
      return const Right(true);
    } catch (e) {
      // Clear session even if remote logout fails
      await localDataSource.clearSession();
      return const Right(true);
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      return Right(localDataSource.isLoggedIn());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AuthTokenEntity?>> getStoredToken() async {
    try {
      final token = localDataSource.getCachedToken();
      return Right(token?.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> autoLogin() async {
    try {
      // Check if user is logged in
      if (!localDataSource.isLoggedIn()) {
        return const Left(UnauthorizedFailure(message: 'No stored session'));
      }

      // Get stored token
      final storedToken = localDataSource.getCachedToken();
      if (storedToken == null) {
        return const Left(UnauthorizedFailure(message: 'No stored token'));
      }

      // Check if token is expired
      if (storedToken.toEntity().isExpired) {
        // Try to refresh token
        final refreshResult = await refreshToken(storedToken.refreshToken);
        if (refreshResult.isLeft()) {
          await localDataSource.clearSession();
          return const Left(UnauthorizedFailure(message: 'Token refresh failed'));
        }
      }

      // Try to get current user from remote
      try {
        final userModel = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(userModel);
        return Right(userModel.toEntity());
      } catch (_) {
        // If remote fails, try to get cached user
        final cachedUser = localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }
        return const Left(UnauthorizedFailure(message: 'Could not retrieve user'));
      }
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

