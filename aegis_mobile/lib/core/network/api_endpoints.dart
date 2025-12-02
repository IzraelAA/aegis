/// API Endpoints for Aegis Mobile
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Configure based on environment
  static const String baseUrl = 'https://aegis-production-d7b4.up.railway.app';

  // Auth
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String refreshToken = '/api/v1/auth/refresh';

  // Users / Profile
  static const String me = '/api/v1/users/me';
  static const String users = '/api/v1/users';
  static String user(String userId) => '/api/v1/users/$userId';
  static String deactivateUser(String userId) =>
      '/api/v1/users/$userId/deactivate';
  static String activateUser(String userId) => '/api/v1/users/$userId/activate';
  static const String searchUsers = '/api/v1/users/search/';
  static String usersByRole(String role) => '/api/v1/users/role/$role';

  // Inspections
  static const String inspections = '/api/v1/inspections';
  static const String myInspections = '/api/v1/inspections/my';
  static String inspectionsByUser(String userId) =>
      '/api/v1/inspections/user/$userId';
  static String inspection(String id) => '/api/v1/inspections/$id';
  static String inspectionStatus(String id) => '/api/v1/inspections/$id/status';

  // Incidents (Reports)
  static const String incidents = '/api/v1/incidents';
  static const String myIncidents = '/api/v1/incidents/my';
  static const String searchIncidents = '/api/v1/incidents/search';
  static String incident(String id) => '/api/v1/incidents/$id';
  static String incidentInvestigation(String id) =>
      '/api/v1/incidents/$id/investigation';

  // Permits (PTW - Permit to Work)
  static const String permits = '/api/v1/permits';
  static const String myPermits = '/api/v1/permits/my';
  static const String pendingPermits = '/api/v1/permits/pending';
  static String permit(String id) => '/api/v1/permits/$id';
  static String approvePermit(String id) => '/api/v1/permits/$id/approve';
  static String rejectPermit(String id) => '/api/v1/permits/$id/reject';

  // Notifications (placeholder - not in provided API)
  static const String notifications = '/api/v1/notifications';
  static const String deviceToken = '/api/v1/notifications/device-token';

  // Real-time
  static const String websocket = '/ws';

  // Dashboard / Stats (placeholder - not in provided API)
  static const String dashboard = '/api/v1/dashboard';
  static const String stats = '/api/v1/stats';
}
