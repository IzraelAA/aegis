import 'package:auto_route/auto_route.dart';
import 'package:aegis_mobile/core/local_storage/hive_storage.dart';
import 'package:aegis_mobile/core/di/injection.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final storage = getIt<HiveStorage>();
    final token = storage.getToken();

    if (token != null && token.isNotEmpty) {
      resolver.next(true);
    } else {
      // Redirect to login if not authenticated
      // router.push(const LoginRoute());
      resolver.next(false);
    }
  }
}

class GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final storage = getIt<HiveStorage>();
    final token = storage.getToken();

    if (token == null || token.isEmpty) {
      resolver.next(true);
    } else {
      // Redirect to home if already authenticated
      // router.replace(const HomeRoute());
      resolver.next(false);
    }
  }
}

