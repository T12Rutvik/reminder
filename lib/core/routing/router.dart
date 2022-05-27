import 'package:flutter/material.dart';
import 'package:reminder/core/routing/routes.dart';

import '../../ui/home_screen.dart';
import '../../ui/set_timer_screen.dart';
import '../../ui/splash_screen.dart';

class PageRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.setTimerScreen:
        bool isUpdate = settings.arguments as bool;
        return MaterialPageRoute(
            builder: (context) => SetTimerScreen(
                  isUpdate: isUpdate,
                ));
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: Center(child: Text('Page not found')),
          );
        });
    }
  }
}
