import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../controllers/home_controller.dart';
import '../../../theme/theme_data.dart';
import 'conversation_history_widget.dart';
import 'package:livekit_client/livekit_client.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Glowing background effect
            _buildGlowingBackground(),

            // Main content
            Column(
              children: [
                // Status bar area
                const SizedBox(height: 20),

                // Voice Recognition indicator
                Center(child: _buildVoiceRecognitionIndicator()),

                const Spacer(),

                // Main text content
                _buildMainText(),

                const Spacer(),

                // AI Response display
                _buildAIResponse(),

                const Spacer(),

                // User Question display
                _buildUserQuestion(),

                const Spacer(),

                // Conversation History
                Obx(
                  () => controller.conversationHistory.isNotEmpty
                      ? ConversationHistoryWidget(
                          messages: controller.conversationHistory,
                        )
                      : const SizedBox.shrink(),
                ),

                const Spacer(),

                // Space for center button
                const SizedBox(height: 80),

                // Control bar
                _buildControlBar(),

                const SizedBox(height: 20),
              ],
            ),

            // Camera preview overlay (full screen)
            Obx(
              () => controller.isCameraActive.value
                  ? _buildCameraPreview()
                  : const SizedBox.shrink(),
            ),

            // Control bar overlay (on top of camera)
            Obx(
              () => controller.isCameraActive.value
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildControlBar(),
                    )
                  : const SizedBox.shrink(),
            ),

            // Center button positioned 50% above control bar (on top of camera)
            Obx(
              () => controller.isCameraActive.value
                  ? Positioned(
                      bottom: 60, // 50% above control bar
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _buildControlButton(
                          icon: controller.isCameraActive.value
                              ? Icons.camera_alt
                              : Icons.mic,
                          onPressed: controller.toggleCamera,
                          isActive: true,
                          isMain: true,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Center button for non-camera state
            Obx(
              () => !controller.isCameraActive.value
                  ? Positioned(
                      bottom: 75, // 50% above control bar
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _buildControlButton(
                          icon: _getMainButtonIcon(),
                          onPressed: controller.toggleVoiceRecognition,
                          isActive: true,
                          isMain: true,
                          isLoading: controller.isBidirectionalAISettingUp,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Processing indicator
            Obx(
              () => controller.isProcessing.value
                  ? _buildProcessingIndicator()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMainButtonIcon() {
    if (controller.isBidirectionalAISettingUp) {
      return Icons.hourglass_empty;
    } else if (controller.isConversationActive.value) {
      return Icons.stop;
    } else {
      return Icons.mic;
    }
  }

  Widget _buildGlowingBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kDarkBackgroundColor, kDarkBackgroundColor.withOpacity(0.8)],
        ),
      ),
      child: CustomPaint(
        painter: GlowingBackgroundPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildVoiceRecognitionIndicator() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _getVoiceRecognitionColor(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVoiceRecognitionDot(),
            const SizedBox(width: 8),
            Text(
              _getVoiceRecognitionText(),
              style: TextStyle(
                color: kWhiteTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getVoiceRecognitionColor() {
    if (controller.isBidirectionalAISettingUp) {
      return kGlowingBlueColor;
    } else if (controller.isConversationActive.value) {
      return kGlowingTealColor;
    } else {
      return kDarkSlateButtonColor.withOpacity(0.5);
    }
  }

  Widget _buildVoiceRecognitionDot() {
    if (controller.isBidirectionalAISettingUp) {
      return SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(kWhiteTextColor),
        ),
      );
    } else {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: controller.isConversationActive.value
              ? kWhiteTextColor
              : kFontColor,
          shape: BoxShape.circle,
        ),
      );
    }
  }

  String _getVoiceRecognitionText() {
    if (controller.isBidirectionalAISettingUp) {
      return 'Setting up...';
    } else if (controller.isConversationActive.value) {
      return 'Listening...';
    } else {
      return 'Voice Recognition';
    }
  }

  Widget _buildMainText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Say anything to',
            style: TextStyle(
              color: kWhiteTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Dr. Nightingale AI!',
            style: TextStyle(
              color: kGlowingTealColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.isConversationActive.value
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: kGlowingTealColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: kGlowingTealColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Live Conversation Active',
                      style: TextStyle(
                        color: kGlowingTealColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIResponse() {
    return Obx(() {
      if (controller.aiResponse.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kGlowingTealColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.smart_toy, color: kGlowingTealColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  controller.isConversationActive.value
                      ? 'AI Response (Live)'
                      : 'AI Response',
                  style: TextStyle(
                    color: kGlowingTealColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (controller.isConversationActive.value)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: kGlowingTealColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              controller.aiResponse.value,
              style: TextStyle(
                color: kWhiteTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildUserQuestion() {
    return Obx(() {
      if (controller.userQuestion.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kDarkSlateButtonColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kFontColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mic, color: kFontColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  controller.isConversationActive.value
                      ? 'Your Voice (Live)'
                      : 'Your Question',
                  style: TextStyle(
                    color: kFontColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              controller.userQuestion.value,
              style: TextStyle(
                color: kWhiteTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProcessingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kGlowingTealColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Processing...',
                style: TextStyle(
                  color: kWhiteTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
      decoration: BoxDecoration(
        color: kDarkSlateButtonColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel button (X)
          _buildControlButton(
            icon: Icons.close,
            onPressed: controller.cancelAction,
            isActive: true,
          ),

          // Confirm button (✓)
          _buildControlButton(
            icon: Icons.check,
            onPressed: controller.confirmAction,
            isActive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
    bool isMain = false,
    Color? color,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: isMain ? 70 : 55,
        height: isMain ? 70 : 55,
        decoration: BoxDecoration(
          color: isMain ? kGlowingTealColor : kCardColor,
          borderRadius: BorderRadius.circular(isMain ? 16 : 12),
          boxShadow: isMain
              ? [
                  BoxShadow(
                    color: kGlowingTealColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kDarkBackgroundColor),
                strokeWidth: 3,
              )
            : Icon(
                icon,
                color: isMain ? kDarkBackgroundColor : kWhiteTextColor,
                size: isMain ? 28 : 24,
              ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Obx(() {
      if (controller.cameraController != null &&
          controller.isCameraInitialized.value) {
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CameraPreview(controller.cameraController!),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}

class GlowingBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          kGlowingTealColor.withOpacity(0.1),
          kGlowingBlueColor.withOpacity(0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw multiple glowing circles
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.2), 100, paint);

    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 150, paint);

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 80, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
