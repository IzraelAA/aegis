import 'package:injectable/injectable.dart';
import 'package:aegis_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:aegis_mobile/features/auth/data/models/user_model.dart';

/// Service for handling demo account credentials and mock data
@lazySingleton
class DemoAccountService {
  /// Demo account credentials
  static const String demoEmail = 'demo@aegis.com';
  static const String demoPassword = 'demo123';

  /// Check if credentials are for demo account
  bool isDemoAccount(String email, String password) {
    return email.toLowerCase() == demoEmail.toLowerCase() &&
        password == demoPassword;
  }

  /// Generate mock auth token for demo account
  AuthTokenModel generateDemoToken() {
    return AuthTokenModel(
      accessToken: 'demo_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'demo_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }

  /// Generate mock user data for demo account
  UserModel generateDemoUser() {
    return UserModel(
      id: 'demo_user_001',
      email: demoEmail,
      name: 'Demo User',
      avatar: null,
      phone: '+1234567890',
      role: 'Safety Officer',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  /// Get demo account info
  Map<String, String> getDemoAccountInfo() {
    return {
      'email': demoEmail,
      'password': demoPassword,
      'name': 'Demo User',
      'role': 'Safety Officer',
    };
  }
}
