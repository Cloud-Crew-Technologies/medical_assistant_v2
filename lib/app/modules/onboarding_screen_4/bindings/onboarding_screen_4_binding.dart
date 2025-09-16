import 'package:get/get.dart';

import '../controllers/onboarding_screen_4_controller.dart';

class OnboardingScreen4Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingScreen4Controller>(
      () => OnboardingScreen4Controller(),
    );
  }
}
