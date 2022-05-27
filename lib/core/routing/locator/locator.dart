import 'package:get_it/get_it.dart';

import '../../view_model/home_view_model/home_screen_model.dart';
import '../../view_model/set_timer_model/set_timer_screen_model.dart';
import '../../view_model/splash_screen_model/splash_screen_view.dart';

final locator = GetIt.instance;

setLocator() {
  locator.registerLazySingleton(() => SplashViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => SetTimerViewModel());
}
