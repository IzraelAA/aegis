import 'package:dio/dio.dart';
import 'package:aegis_mobile/core/network/exception_handler.dart';
import 'package:aegis_mobile/core/network/failure.dart';

/// Base class for all remote data sources
abstract class BaseRemoteDataSource {
  final Dio dio;

  BaseRemoteDataSource(this.dio);

  /// Helper method to handle API calls with error handling
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw ExceptionHandler.handleException(e);
    } catch (e) {
      throw UnknownFailure(message: e.toString());
    }
  }

  /// Helper method to extract data from response
  T extractData<T>(Response response, T Function(dynamic) fromJson) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      // Check if data is wrapped in 'data' key
      if (data.containsKey('data')) {
        return fromJson(data['data']);
      }
      return fromJson(data);
    }
    throw const ServerFailure(message: 'Invalid response format');
  }

  /// Helper method to extract list data from response
  List<T> extractListData<T>(Response response, T Function(dynamic) fromJson) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      // Check if data is wrapped in 'data' key
      final listData = data['data'] ?? data['items'] ?? data['results'];
      if (listData is List) {
        return listData.map((item) => fromJson(item)).toList();
      }
    }
    if (data is List) {
      return data.map((item) => fromJson(item)).toList();
    }
    throw const ServerFailure(message: 'Invalid response format');
  }
}

