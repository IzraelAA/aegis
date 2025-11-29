import 'package:aegis_mobile/core/local_storage/hive_storage.dart';
import 'package:aegis_mobile/core/network/failure.dart';

/// Base class for all local data sources
abstract class BaseLocalDataSource {
  final HiveStorage storage;

  BaseLocalDataSource(this.storage);

  /// Helper method to handle cache operations with error handling
  Future<T> safeCacheCall<T>(Future<T> Function() cacheCall) async {
    try {
      return await cacheCall();
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  /// Check if cache is valid based on timestamp
  bool isCacheValid(String timestampKey, Duration maxAge) {
    final timestamp = storage.get<int>(timestampKey);
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime) < maxAge;
  }

  /// Save data with timestamp
  Future<void> saveWithTimestamp(
      String dataKey, dynamic data, String timestampKey) async {
    await storage.put(dataKey, data);
    await storage.put(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Clear cached data and timestamp
  Future<void> clearCache(String dataKey, String timestampKey) async {
    await storage.delete(dataKey);
    await storage.delete(timestampKey);
  }
}
