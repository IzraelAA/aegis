import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/inspections/domain/entities/inspection_entity.dart';

/// Repository interface for inspections feature
abstract class InspectionRepository {
  /// Get all inspections
  Future<Either<Failure, List<InspectionEntity>>> getInspections();

  /// Get inspection by ID
  Future<Either<Failure, InspectionEntity>> getInspectionById(String id);

  /// Get inspection templates/checklists by category
  Future<Either<Failure, List<InspectionEntity>>> getInspectionTemplates(
      String category);

  /// Start a new inspection from template
  Future<Either<Failure, InspectionEntity>> startInspection(
      InspectionEntity template);

  /// Update inspection progress (save checklist items)
  Future<Either<Failure, InspectionEntity>> updateInspection(
      InspectionEntity inspection);

  /// Submit completed inspection
  Future<Either<Failure, InspectionEntity>> submitInspection(
      InspectionEntity inspection);

  /// Get inspection categories
  Future<Either<Failure, List<String>>> getCategories();
}

