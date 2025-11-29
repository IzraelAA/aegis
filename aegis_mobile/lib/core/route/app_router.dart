import 'package:auto_route/auto_route.dart';
import 'package:aegis_mobile/core/route/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Splash
        AutoRoute(page: SplashRoute.page, initial: true),
        
        // Auth
        AutoRoute(page: LoginRoute.page),
        
        // Main App
        AutoRoute(page: HomeRoute.page),
        
        // Reports
        AutoRoute(page: ReportListRoute.page),
        AutoRoute(page: ReportDetailRoute.page, path: '/reports/:id'),
        AutoRoute(page: CreateReportRoute.page),
        
        // Inspections
        AutoRoute(page: InspectionListRoute.page),
        AutoRoute(page: InspectionFormRoute.page, path: '/inspections/:id'),
        
        // Notifications
        AutoRoute(page: NotificationListRoute.page),
        
        // Profile
        AutoRoute(page: ProfileRoute.page),
      ];

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRouteGuard> get guards => [
        // Add guards here if needed (e.g., AuthGuard)
      ];
}
