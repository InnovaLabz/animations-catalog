// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../download_progress/page.dart' as _i4;
import '../home.dart' as _i3;

class RootRouter extends _i1.RootStackRouter {
  RootRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomRoute.name: (routeData) => _i1.MaterialPageX<String>(
        routeData: routeData,
        builder: (_) {
          return const _i3.HomPage();
        }),
    DownloadProgressRoute.name: (routeData) => _i1.MaterialPageX<String>(
        routeData: routeData,
        builder: (_) {
          return const _i4.DownloadProgressPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomRoute.name, path: '/'),
        _i1.RouteConfig(DownloadProgressRoute.name, path: '/download_progress')
      ];
}

class HomRoute extends _i1.PageRouteInfo {
  const HomRoute() : super(name, path: '/');

  static const String name = 'HomRoute';
}

class DownloadProgressRoute extends _i1.PageRouteInfo {
  const DownloadProgressRoute() : super(name, path: '/download_progress');

  static const String name = 'DownloadProgressRoute';
}
