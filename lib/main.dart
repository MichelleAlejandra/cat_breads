import 'package:cat_breeds_app/core/di/injection_container.dart';
import 'package:cat_breeds_app/core/router/app_router.dart';
import 'package:cat_breeds_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CatBreed',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
