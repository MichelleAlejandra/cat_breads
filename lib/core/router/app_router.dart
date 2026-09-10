import 'package:cat_breeds_app/lib/features/cats/presentation/cat_detail/pages/cat_detail_page.dart';
import 'package:cat_breeds_app/lib/features/cats/presentation/cat_list/pages/cat_list_page.dart';
import 'package:cat_breeds_app/lib/features/splash/presentation/splash_page.dart';
import 'package:go_router/go_router.dart';

/// Central navigation graph. Add new routes here as features grow.
class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: SplashPage.routePath,
    routes: [
      GoRoute(
        path: SplashPage.routePath,
        name: SplashPage.routeName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: CatListPage.routePath,
        name: CatListPage.routeName,
        builder: (context, state) => const CatListPage(),
        routes: [
          GoRoute(
            path: CatDetailPage.routePath,
            name: CatDetailPage.routeName,
            builder: (context, state) => const CatDetailPage(),
          ),
        ],
      ),
    ],
  );
}
