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
  Future<Either<Failure, List<InspectionEntity>>> getInspectionTemplates(
      String category) async {
    try {
      final templates = await remoteDataSource.getInspectionTemplates(category);
      return Right(templates.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, InspectionEntity>> startInspection(
      InspectionEntity template) async {
    try {
      final model = InspectionModel.fromEntity(template);
      final inspection = await remoteDataSource.startInspection(model);

      // Invalidate cache
      await localDataSource.clearInspectionCache();

      return Right(inspection.toEntity());
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
  Future<Either<Failure, InspectionEntity>> submitInspection(
      InspectionEntity inspection) async {
    try {
      final model = InspectionModel.fromEntity(
        inspection.copyWith(
          status: InspectionStatus.completed,
          completedAt: DateTime.now(),
        ),
      );
      final submitted = await remoteDataSource.submitInspection(model);

      // Remove from drafts and invalidate cache
      await localDataSource.deleteDraftInspection(inspection.id);
      await localDataSource.clearInspectionCache();

      return Right(submitted.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      // Return default categories on error
      return const Right([
        'Safety',
        'Equipment',
        'Workplace',
        'Environmental',
        'Quality',
      ]);
    }
  }
}

