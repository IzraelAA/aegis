import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/sample/domain/entities/sample_entity.dart';

/// Repository interface for sample feature
/// This defines the contract between domain and data layer
abstract class SampleRepository {
  /// Get all samples
  Future<Either<Failure, List<SampleEntity>>> getSamples();

  /// Get sample by ID
  Future<Either<Failure, SampleEntity>> getSampleById(String id);

  /// Create a new sample
  Future<Either<Failure, SampleEntity>> createSample(SampleEntity sample);

  /// Update existing sample
  Future<Either<Failure, SampleEntity>> updateSample(SampleEntity sample);

  /// Delete sample by ID
  Future<Either<Failure, bool>> deleteSample(String id);
}

