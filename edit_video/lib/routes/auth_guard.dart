
import 'package:auto_route/auto_route.dart';

import '../../di/locator.dart';
import 'router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    router.push( const SplashScreenRoute());
  }
}
