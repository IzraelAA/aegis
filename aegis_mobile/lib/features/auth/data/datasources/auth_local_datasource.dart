import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/core/data/datasource/base_local_datasource.dart';
import 'package:aegis_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:aegis_mobile/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(AuthTokenModel token);
  AuthTokenModel? getCachedToken();
  Future<void> clearToken();
  
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearUser();
  
  bool isLoggedIn();
  Future<void> clearSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl extends BaseLocalDataSource
    implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token_data';
  static const String _userKey = 'cached_user';

  AuthLocalDataSourceImpl(super.storage);

  @override
  Future<void> cacheToken(AuthTokenModel token) async {
    await safeCacheCall(() async {
      final jsonString = json.encode(token.toJson());
      await storage.put(_tokenKey, jsonString);
      // Also save tokens individually for easy access
      await storage.saveToken(token.accessToken);
      await storage.saveRefreshToken(token.refreshToken);
    });
  }

  @override
  AuthTokenModel? getCachedToken() {
    try {
      final jsonString = storage.get<String>(_tokenKey);
      if (jsonString == null) return null;
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return AuthTokenModel.fromJson(jsonData);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearToken() async {
    await safeCacheCall(() async {
      await storage.delete(_tokenKey);
      await storage.clearToken();
      await storage.clearRefreshToken();
    });
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await safeCacheCall(() async {
      final jsonString = json.encode(user.toJson());
      await storage.put(_userKey, jsonString);
      await storage.saveUserData(user.toJson());
    });
  }

  @override
  UserModel? getCachedUser() {
    try {
      final jsonString = storage.get<String>(_userKey);
      if (jsonString == null) return null;
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonData);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await safeCacheCall(() async {
      await storage.delete(_userKey);
      await storage.clearUserData();
    });
  }

  @override
  bool isLoggedIn() {
    return storage.hasToken();
  }

  @override
  Future<void> clearSession() async {
    await clearToken();
    await clearUser();
    await storage.clearSession();
  }
}

