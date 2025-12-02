import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';

/// Repository interface for inspections feature
abstract class InspectionRepository {
  /// Get all inspections
  Future<Either<Failure, List<InspectionEntity>>> getInspections();

  /// Get my inspections
  Future<Either<Failure, List<InspectionEntity>>> getMyInspections();

  /// Get inspection by ID
  Future<Either<Failure, InspectionEntity>> getInspectionById(String id);

  /// Create a new inspection
  Future<Either<Failure, InspectionEntity>> createInspection(
      InspectionEntity inspection);

  /// Update inspection
  Future<Either<Failure, InspectionEntity>> updateInspection(
      InspectionEntity inspection);

  /// Delete inspection
  Future<Either<Failure, bool>> deleteInspection(String id);

  /// Update inspection status
  Future<Either<Failure, InspectionEntity>> updateInspectionStatus(
      String id, String status);
}
