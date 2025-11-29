import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';

/// Base repository interface that all repositories should extend
/// This provides common methods for CRUD operations
abstract class BaseRepository<T, ID> {
  /// Get all items
  Future<Either<Failure, List<T>>> getAll();

  /// Get item by ID
  Future<Either<Failure, T>> getById(ID id);

  /// Create new item
  Future<Either<Failure, T>> create(T item);

  /// Update existing item
  Future<Either<Failure, T>> update(T item);

  /// Delete item by ID
  Future<Either<Failure, bool>> delete(ID id);
}

/// Simplified repository for read-only operations
abstract class ReadOnlyRepository<T, ID> {
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, T>> getById(ID id);
}

