/// API Endpoints for Aegis Mobile
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Configure based on environment
  static const String baseUrl = 'https://api.aegis.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User / Profile
  static const String user = '/users';
  static const String profile = '/profile';
  static const String profileAvatar = '/profile/avatar';
  static const String changePassword = '/profile/change-password';

  // Reports
  static const String reports = '/reports';
  static const String uploadPhoto = '/uploads/photo';

  // Inspections
  static const String inspections = '/inspections';
  static const String inspectionTemplates = '/inspections/templates';
  static const String inspectionCategories = '/inspections/categories';

  // Notifications
  static const String notifications = '/notifications';
  static const String deviceToken = '/notifications/device-token';

  // Real-time
  static const String websocket = '/ws';

  // Dashboard / Stats
  static const String dashboard = '/dashboard';
  static const String stats = '/stats';
}
