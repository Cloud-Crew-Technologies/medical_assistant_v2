// onboarding_screen_5_view.dart - Medical Issues Selection
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import '../controllers/onboarding_screen_5_controller.dart';
import '../models/medical_condition.dart';

class OnboardingScreen5View extends GetView<OnboardingScreen5Controller> {
  static final List<MedicalCondition> mainConditions = [
    MedicalCondition(name: 'Diabetes', color: 0xFF9C27B0, isLarge: true),
    MedicalCondition(name: 'Arthritis', color: 0xFF2196F3, isLarge: true),
    MedicalCondition(name: 'OCD', color: 0xFFFF9800, isLarge: true),
    MedicalCondition(name: 'Stroke', color: 0xFFE91E63, isLarge: true),
    MedicalCondition(name: 'Alzheimer', color: 0xFF4CAF50, isLarge: true),
    MedicalCondition(name: 'GERD', color: 0xFFFF5722, isLarge: true),
    MedicalCondition(name: 'Thyroid', color: 0xFF9C27B0, isLarge: true),
    MedicalCondition(name: 'Cardiac', color: 0xFFF44336, isLarge: true),
    MedicalCondition(name: 'Depression', color: 0xFF607D8B, isLarge: true),
  ];

  static final List<MedicalCondition> additionalConditions = [
    MedicalCondition(name: 'Asthma', color: 0xFF4CAF50, isLarge: true),
    MedicalCondition(name: 'Hypertension', color: 0xFFF44336, isLarge: true),
    MedicalCondition(name: 'Anxiety', color: 0xFF9C27B0, isLarge: true),
    MedicalCondition(name: 'Migraine', color: 0xFF2196F3),
    MedicalCondition(name: 'Insomnia', color: 0xFF607D8B),
    MedicalCondition(name: 'Allergies', color: 0xFFFF9800),
    MedicalCondition(name: 'Osteoporosis', color: 0xFFE91E63),
    MedicalCondition(name: 'Fibromyalgia', color: 0xFF795548),
    MedicalCondition(name: 'IBS', color: 0xFF00BCD4),
    MedicalCondition(name: 'Chronic Pain', color: 0xFF9E9E9E),
    MedicalCondition(name: 'High Cholesterol', color: 0xFFFFEB3B),
    MedicalCondition(name: 'Sleep Apnea', color: 0xFF3F51B5),
  ];

  const OnboardingScreen5View({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
       backgroundColor: isDark ? kDarkPrimaryBg : kLightPrimaryColor,
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
                      color: isDark ? kDarkCardBg : kButtonColor,
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
                    child: GestureDetector(
                      onTap: controller.goBack,
                      child: Icon(Icons.arrow_back_ios, size: 20, color: kWhiteTextColor),
                    ),
                  ),
                  // Progress bar - fully complete
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kGlowingTealColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 24), // No skip on final screen
                ],
              ),
              SizedBox(height: 30),
              
              // Main content card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? kDarkCardBg : Colors.grey[100],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      // Header section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              'Please specify your\nmedical conditions',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey[800],
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 12),
                            
                            // Total and selected count
                            Row(
                              children: [
                                Text(
                                  '${controller.totalIssues} Total',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.white70 : Colors.grey[500],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Obx(() => Text(
                                  'Selected: ${controller.selectedIssues.length}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? kLightCardColor : kPrimaryColor,
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Medical conditions grid
                      Expanded(
                        child: Column(
                          children: [
                            // Grid section
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.5,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: mainConditions.length,
                                  itemBuilder: (context, index) {
                                    final condition = mainConditions[index];
                                    return _buildMedicalChip(
                                      condition.name,
                                      Color(condition.color),
                                      isLarge: condition.isLarge,
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            // Add more conditions button
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: GestureDetector(
                                onTap: () {
                                  // Show more conditions dialog or navigate to full list
                                  _showMoreConditionsDialog();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isDark ? kLightCardFontColor : Colors.grey[300]!,
                                      style: BorderStyle.solid,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 18,
                                        color: isDark ? Colors.white70 : Colors.grey[600],
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'View more conditions',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark ? Colors.white70 : Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                      
                      // Bottom section with complete button
                      Container(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Complete button
                            ElevatedButton(
                              onPressed: controller.completeOnboarding,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? kDarkSecondaryBg.withOpacity(0.5) : kcontinueButtonColor,
                                minimumSize: Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Complete Setup',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.grey[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            
                          ],
                        ),
                      ),
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

  Widget _buildMedicalChip(String condition, Color color, {bool isLarge = false}) {
    final theme = Theme.of(Get.context!);
    final isDark = theme.brightness == Brightness.dark;
    return Obx(() {
      final isSelected = controller.selectedIssues.contains(condition);
      
      return GestureDetector(
        onTap: () => controller.toggleIssue(condition),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 16 : 12,
            vertical: isLarge ? 12 : 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? isDark ? kDarkSecondaryBg.withOpacity(0.4) : color.withOpacity(0.2) : isDark ? kDarkSecondaryBg.withOpacity(0.4) : Colors.grey[50],
            borderRadius: BorderRadius.circular(isLarge ? 12 : 16),
            border: Border.all(
              color: isSelected ? color : isDark ? kLightCardFontColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            condition,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? color : isDark ? Colors.white : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  void _showMoreConditionsDialog() {
    final theme = Theme.of(Get.context!);
    final isDark = theme.brightness == Brightness.dark;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? kDarkPrimaryBg.withOpacity(0.1) : kLightPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More Conditions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: isDark ? Colors.white : Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              
              // Scrollable conditions list
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: additionalConditions.map((condition) => 
                      Obx(() {
                        final isSelected = controller.selectedIssues.contains(condition.name);
                        final color = Color(condition.color);
                        
                        return GestureDetector(
                          onTap: () => controller.toggleIssue(condition.name),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? isDark ? kDarkSecondaryBg.withOpacity(0.4) : color.withOpacity(0.2) : isDark ? kDarkSecondaryBg.withOpacity(0.4) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? color : isDark ? kLightCardFontColor : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              condition.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? color : isDark ? Colors.white : Colors.grey[700],
                              ),
                            ),
                          ),
                        );
                      })
                    ).toList(),
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