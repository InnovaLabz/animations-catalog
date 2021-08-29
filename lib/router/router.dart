import 'package:animations_catalog/download_progress/page.dart';
import 'package:animations_catalog/home.dart';
import 'package:auto_route/auto_route.dart';

export 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute<String>(
      path: '/',
      page: HomPage,
    ),
    AutoRoute<String>(
      path: '/download_progress',
      page: DownloadProgressPage,
    )
  ],
)
class $RootRouter {}
