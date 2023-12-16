import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../routes/auth_guard.dart';
import '../routes/router.dart';
import '../service/navigation_service.dart';
import 'locator.config.dart';

final locator = GetIt.instance..allowReassignment = true;
ThemeMode themeData = ThemeMode.light;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@injectableInit
Future<void> setupLocator() async {
  _init(locator);
  $initGetIt(locator);
}

void _init(GetIt locator) {
  _registerRouterBuilder(locator);
}
void _registerRouterBuilder(GetIt locator) {
  locator.registerLazySingleton<AppRouter>(
          () => AppRouter(navigatorKey: navigatorKey, authGuard: AuthGuard()));
}



