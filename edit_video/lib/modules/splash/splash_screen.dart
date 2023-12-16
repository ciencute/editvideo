import 'dart:async';

import 'package:flutter/material.dart';
import 'package:edit_video/routes/router.dart';

import '../../di/locator.dart';
import '../../service/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(
      const Duration(seconds: 2), // Chờ 2 giây trước khi điều hướng
          () {
        _finishOpenHome();
      },
    );
  }

  void _finishOpenHome() {
    final navigationService = locator<NavigationService>();
    navigationService.pushAndRemoveUntil(
      const DashboardScreenRoute(),
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

