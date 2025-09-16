import 'package:get/get.dart';

import '../controllers/onboarding_screen_5_controller.dart';

class OnboardingScreen5Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingScreen5Controller>(
      () => OnboardingScreen5Controller(),
    );
  }
}
