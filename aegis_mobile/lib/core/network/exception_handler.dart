import 'package:dio/dio.dart';
import 'package:aegis_mobile/core/network/failure.dart';

class ExceptionHandler {
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    return UnknownFailure(message: error.toString());
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout');
      
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request cancelled');
      
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'No internet connection');
      
      case DioExceptionType.badCertificate:
        return const ServerFailure(message: 'Bad certificate');
      
      case DioExceptionType.unknown:
        return UnknownFailure(message: error.message ?? 'Unknown error');
    }
  }

  static Failure _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final message = _extractErrorMessage(response?.data);

    switch (statusCode) {
      case 400:
        return ServerFailure(message: message ?? 'Bad request', statusCode: 400);
      case 401:
        return UnauthorizedFailure(message: message ?? 'Unauthorized');
      case 403:
        return ServerFailure(message: message ?? 'Forbidden', statusCode: 403);
      case 404:
        return NotFoundFailure(message: message ?? 'Not found');
      case 422:
        return ValidationFailure(message: message ?? 'Validation error');
      case 500:
        return ServerFailure(message: message ?? 'Internal server error', statusCode: 500);
      default:
        return ServerFailure(
          message: message ?? 'Something went wrong',
          statusCode: statusCode,
        );
    }
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map) {
      return data['message'] ?? data['error'] ?? data['msg'];
    }
    return null;
  }
}

