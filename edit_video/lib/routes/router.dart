
import 'package:flutter/material.dart';
import 'package:edit_video/modules/edit_video/edit_video_screen.dart';
import 'package:edit_video/modules/settings/settings_screen.dart';

import '../modules/dashboard/dashboard_screen.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/qr_code/scan_qrcode_screen.dart';
import '../modules/splash/splash_screen.dart';
import 'auth_guard.dart';
import 'package:auto_route/auto_route.dart';
part 'router.gr.dart';


@MaterialAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: SplashScreen, path: 'splash'),
  AutoRoute(page: DashboardScreen, path: 'DashboardScreen',initial: true, guards: [AuthGuard]),
  CustomRoute(
      page: ScanQRCodeScreen,
      path: 'ScanQRCodeScreen',
      transitionsBuilder: TransitionsBuilders.slideBottom),
  AutoRoute(page: SettingsScreen, path: 'setting'),
  AutoRoute(page: EditVideoScreen, path: 'edit_video'),
])
class AppRouter extends _$AppRouter {
  AppRouter({super.navigatorKey, required super.authGuard});
}
