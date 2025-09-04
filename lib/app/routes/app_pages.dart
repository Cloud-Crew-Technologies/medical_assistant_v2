import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/modules/home/bindings/home_binding.dart';
import 'package:medical_assistant_v2/app/modules/home/views/home_view.dart';

import '../modules/Health_metrics_Screen/binding/Health_metrics_binding.dart';
import '../modules/Health_metrics_Screen/view/Health_metrics_view.dart';
import '../modules/chat_screen/bindings/chat_screen_binding.dart';
import '../modules/chat_screen/views/chat_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HEALTH_METRICS;

  static final routes = [
    GetPage(
      name: _Paths.HEALTH_METRICS,
      page: () => const HealthMetricsView(),
      binding: HealthMetricsBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(),
      binding: ChatScreenBinding(),
    ),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
  ];
}
