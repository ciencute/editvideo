import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../routes/router.dart';

/// Singleton navigation service used for navigation between the screens.
/// This service allows navigation from viewmodel without requiring the context
/// details from the widget.
@lazySingleton
class NavigationService {
  final AppRouter _router;

  NavigationService(this._router);

  Future push<T>(PageRouteInfo routeInfo) async {
    try {
      return _router.push(routeInfo);
    } on Exception catch (e) {}
  }

  Future popAndPush(PageRouteInfo routeInfo) async {
    try {
      return _router.popAndPush(routeInfo);
    } on Exception catch (e) {}
  }

  Future pushAndRemoveUntil(
    PageRouteInfo routeInfo, {
    required RoutePredicate predicate,
  }) async {
    try {
      return _router.pushAndPopUntil(routeInfo, predicate: predicate);
    } on Exception catch (e) {}
  }

  Future replace(PageRouteInfo routeInfo) async {
    try {
      return _router.replace(routeInfo);
    } on Exception catch (e) {}
  }

  Future<bool> pop<T extends Object?>([T? result]) {
    try {
      return _router.pop(result);
    } on Exception catch (e) {
      return Future.value(false);
    }
  }

  void popToRoot() {
    try {
      return _router.popUntil((route) => route.isFirst);
    } on Exception catch (e) {}
  }

  RouteData? get currentPage => _router.current;

  Future replaceAll(
    List<PageRouteInfo> routes, {
    OnNavigationFailure? onFailure,
  }) async {
    try {
      return _router.replaceAll(routes, onFailure: onFailure);
    } on Exception catch (e) {}
  }
}
