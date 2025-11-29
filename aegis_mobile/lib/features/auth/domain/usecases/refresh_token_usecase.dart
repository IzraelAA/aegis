import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/domain/usecase/usecase.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/auth/domain/entities/auth_token_entity.dart';
import 'package:aegis_mobile/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class RefreshTokenUseCase implements UseCase<AuthTokenEntity, RefreshTokenParams> {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  @override
  Future<Either<Failure, AuthTokenEntity>> call(RefreshTokenParams params) {
    return repository.refreshToken(params.refreshToken);
  }
}

class RefreshTokenParams extends Equatable {
  final String refreshToken;

  const RefreshTokenParams({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}

