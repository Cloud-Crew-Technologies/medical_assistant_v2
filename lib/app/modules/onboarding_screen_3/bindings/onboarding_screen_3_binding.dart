import 'package:get/get.dart';

import '../controllers/onboarding_screen_3_controller.dart';

class OnboardingScreen3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingScreen3Controller>(
      () => OnboardingScreen3Controller(),
    );
  }
}
