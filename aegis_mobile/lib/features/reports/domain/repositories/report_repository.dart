import 'package:dartz/dartz.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';

/// Repository interface for reports feature
abstract class ReportRepository {
  /// Get all reports
  Future<Either<Failure, List<ReportEntity>>> getReports();

  /// Get report by ID
  Future<Either<Failure, ReportEntity>> getReportById(String id);

  /// Create a new report
  Future<Either<Failure, ReportEntity>> createReport(ReportEntity report);

  /// Update existing report
  Future<Either<Failure, ReportEntity>> updateReport(ReportEntity report);

  /// Delete report by ID
  Future<Either<Failure, bool>> deleteReport(String id);

  /// Get offline queue
  Future<Either<Failure, List<ReportEntity>>> getOfflineQueue();

  /// Add report to offline queue
  Future<Either<Failure, bool>> addToOfflineQueue(ReportEntity report);

  /// Remove from offline queue
  Future<Either<Failure, bool>> removeFromOfflineQueue(String id);

  /// Sync offline queue with server
  Future<Either<Failure, int>> syncOfflineQueue();
}
