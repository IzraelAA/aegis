import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_local_datasource.dart';
import 'package:aegis_mobile/features/inspections/data/models/inspection_model.dart';

abstract class InspectionLocalDataSource {
  Future<List<InspectionModel>> getCachedInspections();
  Future<void> cacheInspections(List<InspectionModel> inspections);
  bool hasCachedInspections();
  Future<void> clearInspectionCache();

  // Draft inspection management
  Future<void> saveDraftInspection(InspectionModel inspection);
  Future<InspectionModel?> getDraftInspection(String id);
  Future<List<InspectionModel>> getAllDrafts();
  Future<void> deleteDraftInspection(String id);
}

@LazySingleton(as: InspectionLocalDataSource)
class InspectionLocalDataSourceImpl extends BaseLocalDataSource
    implements InspectionLocalDataSource {
  static const String _inspectionsKey = 'cached_inspections';
  static const String _timestampKey = 'inspections_timestamp';
  static const String _draftsKey = 'inspection_drafts';
  static const Duration _cacheMaxAge = Duration(minutes: 30);

  InspectionLocalDataSourceImpl(super.storage);

  @override
  Future<List<InspectionModel>> getCachedInspections() async {
    return safeCacheCall(() async {
      final jsonString = storage.get<String>(_inspectionsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => InspectionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> cacheInspections(List<InspectionModel> inspections) async {
    return safeCacheCall(() async {
      final jsonList = inspections.map((i) => i.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await saveWithTimestamp(_inspectionsKey, jsonString, _timestampKey);
    });
  }

  @override
  bool hasCachedInspections() {
    return isCacheValid(_timestampKey, _cacheMaxAge);
  }

  @override
  Future<void> clearInspectionCache() async {
    await clearCache(_inspectionsKey, _timestampKey);
  }

  @override
  Future<void> saveDraftInspection(InspectionModel inspection) async {
    return safeCacheCall(() async {
      final drafts = await getAllDrafts();
      final existingIndex = drafts.indexWhere((d) => d.id == inspection.id);
      if (existingIndex >= 0) {
        drafts[existingIndex] = inspection;
      } else {
        drafts.add(inspection);
      }
      final jsonList = drafts.map((d) => d.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await storage.put(_draftsKey, jsonString);
    });
  }

  @override
  Future<InspectionModel?> getDraftInspection(String id) async {
    final drafts = await getAllDrafts();
    try {
      return drafts.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<InspectionModel>> getAllDrafts() async {
    return safeCacheCall(() async {
      final jsonString = storage.get<String>(_draftsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => InspectionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> deleteDraftInspection(String id) async {
    return safeCacheCall(() async {
      final drafts = await getAllDrafts();
      drafts.removeWhere((d) => d.id == id);
      final jsonList = drafts.map((d) => d.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await storage.put(_draftsKey, jsonString);
    });
  }
}

