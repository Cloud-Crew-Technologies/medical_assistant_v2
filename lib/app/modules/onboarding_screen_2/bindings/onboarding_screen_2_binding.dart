import 'package:get/get.dart';

import '../controllers/onboarding_screen_2_controller.dart';

class OnboardingScreen2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingScreen2Controller>(
      () => OnboardingScreen2Controller(),
    );
  }
}
