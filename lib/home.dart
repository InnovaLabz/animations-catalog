import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'router/router.dart';

class DemoPage {
  final String title;
  final PageRouteInfo<dynamic> route;

  const DemoPage({required this.title, required this.route});
}

final animations = [
  const DemoPage(title: 'Download Progress', route: DownloadProgressRoute()),
];

class HomPage extends StatelessWidget {
  const HomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Catalog'),
      ),
      body: ListView.builder(
        itemCount: animations.length,
        itemBuilder: (context, index) {
          final animation = animations[index];
          return ListTile(
            title: Text(animation.title),
            onTap: () => context.pushRoute(animation.route),
          );
        },
      ),
    );
  }
}
