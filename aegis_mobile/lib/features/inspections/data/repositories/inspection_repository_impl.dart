import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/inspections/data/datasources/inspection_local_datasource.dart';
import 'package:aegis_mobile/features/inspections/data/datasources/inspection_remote_datasource.dart';
import 'package:aegis_mobile/features/inspections/data/models/inspection_model.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';
import 'package:aegis_mobile/features/inspections/domain/repositories/inspection_repository.dart';

@LazySingleton(as: InspectionRepository)
class InspectionRepositoryImpl implements InspectionRepository {
  final InspectionRemoteDataSource remoteDataSource;
  final InspectionLocalDataSource localDataSource;

  InspectionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<InspectionEntity>>> getInspections() async {
    try {
      // Try cached data first
      if (localDataSource.hasCachedInspections()) {
        final cached = await localDataSource.getCachedInspections();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      }

      // Fetch from remote
      final remote = await remoteDataSource.getInspections();
      await localDataSource.cacheInspections(remote);
      return Right(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      // Fallback to cached data
      try {
        final cached = await localDataSource.getCachedInspections();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<InspectionEntity>>> getMyInspections() async {
    try {
      final remote = await remoteDataSource.getMyInspections();
      return Right(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, InspectionEntity>> getInspectionById(String id) async {
    try {
      final inspection = await remoteDataSource.getInspectionById(id);
      return Right(inspection.toEntity());
    } catch (e) {
      // Try to get from drafts
      final draft = await localDataSource.getDraftInspection(id);
      if (draft != null) {
        return Right(draft.toEntity());
      }
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, InspectionEntity>> createInspection(
      InspectionEntity inspection) async {
    try {
      final model = InspectionModel.fromEntity(inspection);
      final created = await remoteDataSource.createInspection(model);

      // Invalidate cache
      await localDataSource.clearInspectionCache();

      return Right(created.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, InspectionEntity>> updateInspection(
      InspectionEntity inspection) async {
    try {
      final model = InspectionModel.fromEntity(inspection);

      // Save as draft locally
      await localDataSource.saveDraftInspection(model);

      // Try to sync with server
      try {
        final updated = await remoteDataSource.updateInspection(model);
        return Right(updated.toEntity());
      } catch (_) {
        // Return local version if sync fails
        return Right(inspection);
      }
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteInspection(String id) async {
    try {
      await remoteDataSource.deleteInspection(id);

      // Remove from drafts and invalidate cache
      await localDataSource.deleteDraftInspection(id);
      await localDataSource.clearInspectionCache();

      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, InspectionEntity>> updateInspectionStatus(
      String id, String status) async {
    try {
      final updated = await remoteDataSource.updateInspectionStatus(id, status);

      // Invalidate cache
      await localDataSource.clearInspectionCache();

      return Right(updated.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}
