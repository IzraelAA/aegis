import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:aegis_mobile/core/network/failure.dart';

/// Base class for all use cases
/// [Type] is the return type
/// [Params] is the parameters class
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this when the use case doesn't need any parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Use this for pagination parameters
class PaginationParams extends Equatable {
  final int page;
  final int limit;

  const PaginationParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Use this for ID-based parameters
class IdParams extends Equatable {
  final String id;

  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Stream-based use case
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

