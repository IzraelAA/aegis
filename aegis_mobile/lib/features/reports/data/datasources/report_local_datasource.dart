import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_local_datasource.dart';
import 'package:aegis_mobile/features/reports/data/models/report_model.dart';

abstract class ReportLocalDataSource {
  Future<List<ReportModel>> getCachedReports();
  Future<void> cacheReports(List<ReportModel> reports);
  bool hasCachedReports();
  Future<void> clearReportCache();

  // Offline queue management
  Future<List<ReportModel>> getOfflineQueue();
  Future<void> addToOfflineQueue(ReportModel report);
  Future<void> removeFromOfflineQueue(String id);
  Future<void> clearOfflineQueue();
  bool hasOfflineQueue();
}

@LazySingleton(as: ReportLocalDataSource)
class ReportLocalDataSourceImpl extends BaseLocalDataSource
    implements ReportLocalDataSource {
  static const String _reportsKey = 'cached_reports';
  static const String _timestampKey = 'reports_timestamp';
  static const String _offlineQueueKey = 'offline_reports_queue';
  static const Duration _cacheMaxAge = Duration(minutes: 30);

  ReportLocalDataSourceImpl(super.storage);

  @override
  Future<List<ReportModel>> getCachedReports() async {
    return safeCacheCall(() async {
      final jsonString = storage.get<String>(_reportsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> cacheReports(List<ReportModel> reports) async {
    return safeCacheCall(() async {
      final jsonList = reports.map((r) => r.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await saveWithTimestamp(_reportsKey, jsonString, _timestampKey);
    });
  }

  @override
  bool hasCachedReports() {
    return isCacheValid(_timestampKey, _cacheMaxAge);
  }

  @override
  Future<void> clearReportCache() async {
    await clearCache(_reportsKey, _timestampKey);
  }

  @override
  Future<List<ReportModel>> getOfflineQueue() async {
    return safeCacheCall(() async {
      final jsonString = storage.get<String>(_offlineQueueKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> addToOfflineQueue(ReportModel report) async {
    return safeCacheCall(() async {
      final queue = await getOfflineQueue();
      // Check if already exists
      final existingIndex = queue.indexWhere((r) => r.id == report.id);
      if (existingIndex >= 0) {
        queue[existingIndex] = report;
      } else {
        queue.add(report);
      }
      final jsonList = queue.map((r) => r.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await storage.put(_offlineQueueKey, jsonString);
    });
  }

  @override
  Future<void> removeFromOfflineQueue(String id) async {
    return safeCacheCall(() async {
      final queue = await getOfflineQueue();
      queue.removeWhere((r) => r.id == id);
      final jsonList = queue.map((r) => r.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await storage.put(_offlineQueueKey, jsonString);
    });
  }

  @override
  Future<void> clearOfflineQueue() async {
    await storage.delete(_offlineQueueKey);
  }

  @override
  bool hasOfflineQueue() {
    final jsonString = storage.get<String>(_offlineQueueKey);
    if (jsonString == null) return false;
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

