import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import '../controllers/onboarding_screen_4_controller.dart';

class OnboardingScreen4View extends GetView<OnboardingScreen4Controller> {
  const OnboardingScreen4View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7FFFD4),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kLightButtonColor,
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
                    child: GestureDetector(
                      onTap: controller.goBack,
                      child: Icon(Icons.arrow_back_ios, size: 20),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF26C6A8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.skip,
                    child: Text('Skip', style: TextStyle(fontSize: 16)),
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
                        'How would you rate your\nsleep level?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 60),
                      
                      // Sleep level display
                      Obx(() => Column(
                        children: [
                          // Large number
                          Text(
                            controller.sleepLevel.value.toString(),
                            style: TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Label
                          Text(
                            controller.currentSleepLabel,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          
                          // Description with icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                controller.currentSleepDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      
                      SizedBox(height: 60),
                      
                      // Slider
                      Obx(() => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Color(0xFF26C6A8),
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Color(0xFF26C6A8),
                          trackHeight: 6,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Slider(
                          value: controller.sleepLevel.value.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: (value) => controller.setSleepLevel(value.round()),
                        ),
                      )),
                      
                      Spacer(),
                      
                      // Continue button
                      ElevatedButton(
                        onPressed: controller.continueToNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF26C6A8),
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
                      
                      // Progress indicator
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
