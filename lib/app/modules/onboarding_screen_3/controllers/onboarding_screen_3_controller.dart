import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/routes/app_pages.dart';

class OnboardingScreen3Controller extends GetxController {
  final selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void continueToNext() {
    if (selectedRole.value.isEmpty) {
      Get.snackbar('Error', 'Please select your role');
      return;
    }
    Get.toNamed(Routes.ONBOARDING_SCREEN_4);
  }

  void skip() {
    Get.toNamed(Routes.ONBOARDING_SCREEN_4);
  }

  void goBack() {
    Get.back();
  }
}