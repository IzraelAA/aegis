import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/sample/data/datasources/sample_local_datasource.dart';
import 'package:aegis_mobile/features/sample/data/datasources/sample_remote_datasource.dart';
import 'package:aegis_mobile/features/sample/data/models/sample_model.dart';
import 'package:aegis_mobile/features/sample/domain/entities/sample_entity.dart';
import 'package:aegis_mobile/features/sample/domain/repositories/sample_repository.dart';

@LazySingleton(as: SampleRepository)
class SampleRepositoryImpl implements SampleRepository {
  final SampleRemoteDataSource remoteDataSource;
  final SampleLocalDataSource localDataSource;

  SampleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<SampleEntity>>> getSamples() async {
    try {
      // Try to get cached data first
      if (localDataSource.hasCachedSamples()) {
        final cachedSamples = await localDataSource.getCachedSamples();
        if (cachedSamples.isNotEmpty) {
          return Right(cachedSamples.map((m) => m.toEntity()).toList());
        }
      }

      // Fetch from remote
      final remoteSamples = await remoteDataSource.getSamples();

      // Cache the data
      await localDataSource.cacheSamples(remoteSamples);

      return Right(remoteSamples.map((m) => m.toEntity()).toList());
    } catch (e) {
      // If remote fails, try to get cached data
      try {
        final cachedSamples = await localDataSource.getCachedSamples();
        if (cachedSamples.isNotEmpty) {
          return Right(cachedSamples.map((m) => m.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SampleEntity>> getSampleById(String id) async {
    try {
      final sample = await remoteDataSource.getSampleById(id);
      return Right(sample.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SampleEntity>> createSample(
      SampleEntity sample) async {
    try {
      final model = SampleModel.fromEntity(sample);
      final createdSample = await remoteDataSource.createSample(model);

      // Invalidate cache
      await localDataSource.clearSampleCache();

      return Right(createdSample.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SampleEntity>> updateSample(
      SampleEntity sample) async {
    try {
      final model = SampleModel.fromEntity(sample);
      final updatedSample = await remoteDataSource.updateSample(model);

      // Invalidate cache
      await localDataSource.clearSampleCache();

      return Right(updatedSample.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSample(String id) async {
    try {
      await remoteDataSource.deleteSample(id);

      // Invalidate cache
      await localDataSource.clearSampleCache();

      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}
