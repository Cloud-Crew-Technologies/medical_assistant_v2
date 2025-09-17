import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/routes/app_pages.dart';

class OnboardingScreen5Controller extends GetxController {
  final selectedIssues = <String>[].obs;
  final totalIssues = 251;
  
  final medicalIssues = [
    {'name': 'Diabetes', 'color': 0xFF9C27B0},
    {'name': 'Arthritis', 'color': 0xFF2196F3},
    {'name': 'OCD', 'color': 0xFFFF9800},
    {'name': 'Stroke', 'color': 0xFFE91E63},
    {'name': 'Alzheimer', 'color': 0xFF4CAF50},
    {'name': 'GERD', 'color': 0xFFFF5722},
    {'name': 'Thyroid', 'color': 0xFF9C27B0},
    {'name': 'Cardiac', 'color': 0xFFF44336},
    {'name': 'Depression', 'color': 0xFF607D8B},
  ];

  void toggleIssue(String issue) {
    if (selectedIssues.contains(issue)) {
      selectedIssues.remove(issue);
    } else {
      selectedIssues.add(issue);
    }
  }

  void completeOnboarding() {
    // Save all onboarding data and navigate to main app
    Get.offAllNamed(Routes.HEALTH_METRICS);
  }

  void goBack() {
    Get.back();
  }
}