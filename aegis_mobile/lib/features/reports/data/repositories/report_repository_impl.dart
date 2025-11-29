import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';
import 'package:aegis_mobile/features/reports/data/datasources/report_local_datasource.dart';
import 'package:aegis_mobile/features/reports/data/datasources/report_remote_datasource.dart';
import 'package:aegis_mobile/features/reports/data/models/report_model.dart';
import 'package:aegis_mobile/features/reports/domain/entities/report_entity.dart';
import 'package:aegis_mobile/features/reports/domain/repositories/report_repository.dart';

@LazySingleton(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final ReportLocalDataSource localDataSource;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ReportEntity>>> getReports() async {
    try {
      // Try to get cached data first
      if (localDataSource.hasCachedReports()) {
        final cachedReports = await localDataSource.getCachedReports();
        if (cachedReports.isNotEmpty) {
          return Right(cachedReports.map((m) => m.toEntity()).toList());
        }
      }

      // Fetch from remote
      final remoteReports = await remoteDataSource.getReports();

      // Cache the data
      await localDataSource.cacheReports(remoteReports);

      return Right(remoteReports.map((m) => m.toEntity()).toList());
    } catch (e) {
      // If remote fails, try to get cached data
      try {
        final cachedReports = await localDataSource.getCachedReports();
        if (cachedReports.isNotEmpty) {
          return Right(cachedReports.map((m) => m.toEntity()).toList());
        }
      } catch (_) {
        // Ignore cache errors
      }
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> getReportById(String id) async {
    try {
      final report = await remoteDataSource.getReportById(id);
      return Right(report.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> createReport(ReportEntity report) async {
    try {
      final model = ReportModel.fromEntity(report);
      final createdReport = await remoteDataSource.createReport(model);

      // Invalidate cache
      await localDataSource.clearReportCache();

      return Right(createdReport.toEntity());
    } catch (e) {
      // If network fails, add to offline queue
      final offlineReport = report.copyWith(isOffline: true);
      final model = ReportModel.fromEntity(offlineReport);
      await localDataSource.addToOfflineQueue(model);
      return Right(offlineReport);
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> updateReport(ReportEntity report) async {
    try {
      final model = ReportModel.fromEntity(report);
      final updatedReport = await remoteDataSource.updateReport(model);

      // Invalidate cache
      await localDataSource.clearReportCache();

      return Right(updatedReport.toEntity());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReport(String id) async {
    try {
      await remoteDataSource.deleteReport(id);

      // Invalidate cache
      await localDataSource.clearReportCache();

      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(String filePath) async {
    try {
      final url = await remoteDataSource.uploadPhoto(filePath);
      return Right(url);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getOfflineQueue() async {
    try {
      final queue = await localDataSource.getOfflineQueue();
      return Right(queue.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> addToOfflineQueue(ReportEntity report) async {
    try {
      final model = ReportModel.fromEntity(report.copyWith(isOffline: true));
      await localDataSource.addToOfflineQueue(model);
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromOfflineQueue(String id) async {
    try {
      await localDataSource.removeFromOfflineQueue(id);
      return const Right(true);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, int>> syncOfflineQueue() async {
    try {
      final queue = await localDataSource.getOfflineQueue();
      int syncedCount = 0;

      for (final report in queue) {
        try {
          // Create report without offline flag
          final syncedModel = ReportModel(
            id: report.id,
            title: report.title,
            description: report.description,
            severity: report.severity,
            status: report.status,
            latitude: report.latitude,
            longitude: report.longitude,
            locationName: report.locationName,
            photoUrls: report.photoUrls,
            reporterId: report.reporterId,
            reporterName: report.reporterName,
            createdAt: report.createdAt,
            updatedAt: report.updatedAt,
            isOffline: false,
          );
          await remoteDataSource.createReport(syncedModel);
          await localDataSource.removeFromOfflineQueue(report.id);
          syncedCount++;
        } catch (_) {
          // Continue with next report if one fails
        }
      }

      // Refresh cache after sync
      if (syncedCount > 0) {
        await localDataSource.clearReportCache();
      }

      return Right(syncedCount);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

