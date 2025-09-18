import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import '../controllers/onboarding_screen_3_controller.dart';

class Role {
  final String title;
  final IconData icon;
  final Color color;

  const Role({required this.title, required this.icon, required this.color});
}

class OnboardingScreen3View extends GetView<OnboardingScreen3Controller> {
  static final List<Role> roles = [
    Role(title: 'Student', icon: Icons.school, color: Color(0xFF2196F3)),
    Role(title: 'Employed', icon: Icons.business, color: Color(0xFFFF9800)),
    Role(title: 'Self-Employed', icon: Icons.work, color: Color(0xFF4CAF50)),
    Role(title: 'Unemployed', icon: Icons.person_outline, color: Color(0xFF9C27B0)),
  ];
  const OnboardingScreen3View({super.key});

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
                      widthFactor: 0.6,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kGlowingTealColor,
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
                    color: isDark ? kDarkCardBg : Colors.grey[100],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      
                      // Title
                      Text(
                        'Are you a Student,\n or Employeed?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 40),
                      
                      // Role cards
                      Expanded(
                        flex: 2,
                        child: ListView.separated(
                          // physics: ScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: roles.length,
                          separatorBuilder: (context, index) => SizedBox(height: 16),
                          itemBuilder: (context, index) => _buildRoleCard(
                            roles[index].title,
                            roles[index].icon,
                            roles[index].color,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Continue button
                      ElevatedButton(
                        onPressed: controller.continueToNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? kDarkSecondaryBg.withOpacity(0.5) : kcontinueButtonColor,
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
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: isDark ? Colors.white : Colors.black),
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

  Widget _buildRoleCard(String title, IconData icon, Color color) {
    final theme = Theme.of(Get.context!);
    final isDark = theme.brightness == Brightness.dark;
    return Obx(() => GestureDetector(
      onTap: () => controller.selectRole(title),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: controller.selectedRole.value == title ? isDark ? kDarkSecondaryBg.withOpacity(0.4) : color.withOpacity(0.2) : isDark ? kDarkSecondaryBg.withOpacity(0.4) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.selectedRole.value == title ? isDark ? color.withOpacity(0.5) : color : isDark ? kLightCardFontColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}