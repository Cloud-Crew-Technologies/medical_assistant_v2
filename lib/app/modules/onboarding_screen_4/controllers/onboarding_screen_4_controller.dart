import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/routes/app_pages.dart';

class OnboardingScreen4Controller extends GetxController {
  final sleepLevel = 3.obs;
  final sleepLabels = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
  final sleepDescriptions = ['1-3hr daily', '3-5hr daily', '5-7hr daily', '7-8hr daily', '8+ hr daily'];

  void setSleepLevel(int level) {
    sleepLevel.value = level;
  }

  String get currentSleepLabel => sleepLabels[sleepLevel.value - 1];
  String get currentSleepDescription => sleepDescriptions[sleepLevel.value - 1];

  void continueToNext() {
    Get.toNamed(Routes.ONBOARDING_SCREEN_5);
  }

  void skip() {
    Get.toNamed(Routes.ONBOARDING_SCREEN_5);
  }

  void goBack() {
    Get.back();
  }
}