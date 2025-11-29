import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_local_datasource.dart';
import 'package:aegis_mobile/features/sample/data/models/sample_model.dart';

abstract class SampleLocalDataSource {
  Future<List<SampleModel>> getCachedSamples();
  Future<void> cacheSamples(List<SampleModel> samples);
  bool hasCachedSamples();
  Future<void> clearSampleCache();
}

@LazySingleton(as: SampleLocalDataSource)
class SampleLocalDataSourceImpl extends BaseLocalDataSource
    implements SampleLocalDataSource {
  static const String _samplesKey = 'cached_samples';
  static const String _timestampKey = 'samples_timestamp';
  static const Duration _cacheMaxAge = Duration(hours: 1);

  SampleLocalDataSourceImpl(super.storage);

  @override
  Future<List<SampleModel>> getCachedSamples() async {
    return safeCacheCall(() async {
      final jsonString = storage.get<String>(_samplesKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => SampleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> cacheSamples(List<SampleModel> samples) async {
    return safeCacheCall(() async {
      final jsonList = samples.map((s) => s.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await saveWithTimestamp(_samplesKey, jsonString, _timestampKey);
    });
  }

  @override
  bool hasCachedSamples() {
    return isCacheValid(_timestampKey, _cacheMaxAge);
  }

  @override
  Future<void> clearSampleCache() async {
    await clearCache(_samplesKey, _timestampKey);
  }
}
