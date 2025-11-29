import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/auth/demo_account_service.dart';
import 'package:aegis_mobile/core/data/datasource/base_remote_datasource.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';
import 'package:aegis_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:aegis_mobile/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  });
  Future<AuthTokenModel> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<bool> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDataSource {
  final DemoAccountService _demoAccountService;

  AuthRemoteDataSourceImpl(
    super.dio,
    this._demoAccountService,
  );

  @override
  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    // Check if this is a demo account
    if (_demoAccountService.isDemoAccount(email, password)) {
      // Return mock token for demo account
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulate network delay
      return _demoAccountService.generateDemoToken();
    }

    // Regular API call for real accounts
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return extractData<AuthTokenModel>(
        response,
        (json) => AuthTokenModel.fromJson(json),
      );
    });
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {
          'refresh_token': refreshToken,
        },
      );
      return extractData<AuthTokenModel>(
        response,
        (json) => AuthTokenModel.fromJson(json),
      );
    });
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Check if current token is a demo token
    // We check the Authorization header which is set by the interceptor
    try {
      final authHeader = dio.options.headers['Authorization'] as String?;
      if (authHeader != null && authHeader.contains('demo_access_token')) {
        // Return mock user for demo account
        await Future.delayed(
            const Duration(milliseconds: 300)); // Simulate network delay
        return _demoAccountService.generateDemoUser();
      }
    } catch (_) {
      // If we can't check, proceed with regular API call
    }

    // Regular API call for real accounts
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.me);
      return extractData<UserModel>(
        response,
        (json) => UserModel.fromJson(json),
      );
    });
  }

  @override
  Future<bool> logout() async {
    return safeApiCall(() async {
      await dio.post(ApiEndpoints.logout);
      return true;
    });
  }
}
