import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/routes/app_pages.dart';

class OnboardingScreen2Controller extends GetxController {
  final RxInt selectedAge = 25.obs;
  final List<int> ages = List.generate(83, (index) => index + 18).obs; // Ages 18-100

  void selectAge(int age) {
    selectedAge.value = age;
  }

  void goBack() {
    Get.back();
  }

  void skip() {
    // TODO: Implement skip functionality
    Get.toNamed(Routes.ONBOARDING_SCREEN_3);
  }

  void continueToNext() {
    if (selectedAge.value > 0) {
      Get.toNamed(Routes.ONBOARDING_SCREEN_3);
    }
  }
}