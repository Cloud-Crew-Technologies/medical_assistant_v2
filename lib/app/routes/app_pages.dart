import 'package:get/get.dart';

import '../modules/Health_metrics_Screen/binding/Health_metrics_binding.dart';
import '../modules/Health_metrics_Screen/view/Health_metrics_view.dart';
import '../modules/chat_history/bindings/chat_history_binding.dart';
import '../modules/chat_history/views/chat_history_view.dart';
import '../modules/chat_screen/bindings/chat_screen_binding.dart';
import '../modules/chat_screen/views/chat_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/meet/pages/connect.dart';
import '../modules/onboarding_screen_2/bindings/onboarding_screen_2_binding.dart';
import '../modules/onboarding_screen_2/views/onboarding_screen_2_view.dart';
import '../modules/onboarding_screen_3/bindings/onboarding_screen_3_binding.dart';
import '../modules/onboarding_screen_3/views/onboarding_screen_3_view.dart';
import '../modules/onboarding_screen_4/bindings/onboarding_screen_4_binding.dart';
import '../modules/onboarding_screen_4/views/onboarding_screen_4_view.dart';
import '../modules/onboarding_screen_5/bindings/onboarding_screen_5_binding.dart';
import '../modules/onboarding_screen_5/views/onboarding_screen_5_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING_SCREEN_2;

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
    GetPage(name: _Paths.MEET_CONNECT, page: () => const ConnectPage()),
    GetPage(
      name: _Paths.CHAT_HISTORY,
      page: () => const ChatHistoryView(),
      binding: ChatHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN_2,
      page: () => const OnboardingScreen2View(),
      binding: OnboardingScreen2Binding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN_3,
      page: () => const OnboardingScreen3View(),
      binding: OnboardingScreen3Binding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN_4,
      page: () => const OnboardingScreen4View(),
      binding: OnboardingScreen4Binding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_SCREEN_5,
      page: () => const OnboardingScreen5View(),
      binding: OnboardingScreen5Binding(),
    ),
  ];
}
