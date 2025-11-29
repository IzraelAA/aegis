import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static const String _boxName = 'aegis_mobile_storage';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _onboardingKey = 'is_onboarded';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _offlineQueueKey = 'offline_queue';

  late Box<dynamic> _box;

  HiveStorage._();

  static Future<HiveStorage> init() async {
    await Hive.initFlutter();
    final instance = HiveStorage._();
    instance._box = await Hive.openBox(_boxName);
    return instance;
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await _box.put(_tokenKey, token);
  }

  String? getToken() {
    return _box.get(_tokenKey);
  }

  Future<void> clearToken() async {
    await _box.delete(_tokenKey);
  }

  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _box.put(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _box.get(_refreshTokenKey);
  }

  Future<void> clearRefreshToken() async {
    await _box.delete(_refreshTokenKey);
  }

  // User Data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.put(_userKey, userData);
  }

  Map<String, dynamic>? getUserData() {
    final data = _box.get(_userKey);
    if (data != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  Future<void> clearUserData() async {
    await _box.delete(_userKey);
  }

  // Onboarding Status
  Future<void> setOnboarded(bool value) async {
    await _box.put(_onboardingKey, value);
  }

  bool isOnboarded() {
    return _box.get(_onboardingKey, defaultValue: false);
  }

  // Theme Mode
  Future<void> saveThemeMode(String mode) async {
    await _box.put(_themeKey, mode);
  }

  String getThemeMode() {
    return _box.get(_themeKey, defaultValue: 'system');
  }

  // Language
  Future<void> saveLanguage(String language) async {
    await _box.put(_languageKey, language);
  }

  String getLanguage() {
    return _box.get(_languageKey, defaultValue: 'en');
  }

  // Offline Queue Management
  Future<void> addToOfflineQueue(Map<String, dynamic> item) async {
    final queue = getOfflineQueue();
    queue.add(item);
    await _box.put(_offlineQueueKey, queue);
  }

  List<Map<String, dynamic>> getOfflineQueue() {
    final data = _box.get(_offlineQueueKey);
    if (data != null && data is List) {
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  Future<void> removeFromOfflineQueue(String id) async {
    final queue = getOfflineQueue();
    queue.removeWhere((item) => item['id'] == id);
    await _box.put(_offlineQueueKey, queue);
  }

  Future<void> clearOfflineQueue() async {
    await _box.delete(_offlineQueueKey);
  }

  bool hasOfflineQueue() {
    return getOfflineQueue().isNotEmpty;
  }

  // Generic Methods
  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
  }

  T? get<T>(String key, {T? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  // Clear All Data
  Future<void> clearAll() async {
    await _box.clear();
  }

  // Clear User Session
  Future<void> clearSession() async {
    await clearToken();
    await clearRefreshToken();
    await clearUserData();
  }
}
