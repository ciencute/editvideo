// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final AuthGuard authGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    DashboardScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const DashboardScreen(),
      );
    },
    ScanQRCodeScreenRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ScanQRCodeScreen(),
        transitionsBuilder: TransitionsBuilders.slideBottom,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SettingsScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    EditVideoScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const EditVideoScreen(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'DashboardScreen',
          fullMatch: true,
        ),
        RouteConfig(
          SplashScreenRoute.name,
          path: 'splash',
        ),
        RouteConfig(
          DashboardScreenRoute.name,
          path: 'DashboardScreen',
          guards: [authGuard],
        ),
        RouteConfig(
          ScanQRCodeScreenRoute.name,
          path: 'ScanQRCodeScreen',
        ),
        RouteConfig(
          SettingsScreenRoute.name,
          path: 'setting',
        ),
        RouteConfig(
          EditVideoScreenRoute.name,
          path: 'edit_video',
        ),
      ];
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute()
      : super(
          SplashScreenRoute.name,
          path: 'splash',
        );

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [DashboardScreen]
class DashboardScreenRoute extends PageRouteInfo<void> {
  const DashboardScreenRoute()
      : super(
          DashboardScreenRoute.name,
          path: 'DashboardScreen',
        );

  static const String name = 'DashboardScreenRoute';
}

/// generated route for
/// [ScanQRCodeScreen]
class ScanQRCodeScreenRoute extends PageRouteInfo<void> {
  const ScanQRCodeScreenRoute()
      : super(
          ScanQRCodeScreenRoute.name,
          path: 'ScanQRCodeScreen',
        );

  static const String name = 'ScanQRCodeScreenRoute';
}

/// generated route for
/// [SettingsScreen]
class SettingsScreenRoute extends PageRouteInfo<void> {
  const SettingsScreenRoute()
      : super(
          SettingsScreenRoute.name,
          path: 'setting',
        );

  static const String name = 'SettingsScreenRoute';
}

/// generated route for
/// [EditVideoScreen]
class EditVideoScreenRoute extends PageRouteInfo<void> {
  const EditVideoScreenRoute()
      : super(
          EditVideoScreenRoute.name,
          path: 'edit_video',
        );

  static const String name = 'EditVideoScreenRoute';
}
