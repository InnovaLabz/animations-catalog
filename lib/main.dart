import 'package:animations_catalog/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _rootRouter = RootRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Animation Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: AutoRouterDelegate(
        _rootRouter,
      ),
      routeInformationParser: _rootRouter.defaultRouteParser(),
    );
  }
}
