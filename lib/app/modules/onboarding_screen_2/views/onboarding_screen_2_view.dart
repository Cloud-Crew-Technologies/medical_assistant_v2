import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import '../controllers/onboarding_screen_2_controller.dart';

class OnboardingScreen2View extends GetView<OnboardingScreen2Controller> {
  const OnboardingScreen2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top bar with back and skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kLightTextButtonColor,
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
                    child: GestureDetector(
                      onTap: controller.goBack,
                      child: Icon(Icons.arrow_back_ios, size: 16),
                    ),
                  ),
                  // Progress bar
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kGlowingTealColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Spacer(),
                  // Skip button
                  GestureDetector(
                    onTap: controller.skip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: kWhiteTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              
              // Main content card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      
                      // Title
                      Text(
                        'Please tell us your\ncurrent age',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 40),
                      
                      // Age selector
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Obx(() => ListWheelScrollView.useDelegate(
                          itemExtent: 100,
                          diameterRatio: 4.5,
                          perspective: 0.005,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) => controller.selectAge(controller.ages[index]),
                          controller: FixedExtentScrollController(initialItem: controller.ages.indexOf(controller.selectedAge.value)),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: controller.ages.length,
                            builder: (context, index) {
                              final age = controller.ages[index];
                              final isSelected = age == controller.selectedAge.value;
                            
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? kPrimaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  age.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSelected ? 48 : 32,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.black : Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                          ],
                        ),
                      ),
                      
                      // Continue button
                      ElevatedButton(
                        onPressed: controller.continueToNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLightButtonColor,
                          minimumSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}