import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../../../data/services/ai_service.dart';
import '../../../data/services/speech_service.dart';
import '../../../data/services/firebase_service.dart';
import '../../../data/services/bidirectional_ai_service.dart';
import '../../../data/services/ai_settings_service.dart';
import '../models/conversation_message.dart';

class HomeController extends GetxController {
  // Services
  final AIService _aiService = AIService();
  final FirebaseService _firebaseService = FirebaseService();
  final AISettingsService _aiSettingsService = Get.put(AISettingsService());
  final BidirectionalAIService _bidirectionalAIService = Get.put(
    BidirectionalAIService(),
  );

  // Camera
  CameraController? cameraController;
  List<CameraDescription> cameras = [];

  // Observable variables
  final isCameraInitialized = false.obs;
  final isVoiceRecognitionActive = false.obs;
  final isCameraActive = false.obs;
  final isRecording = false.obs;
  final isProcessing = false.obs;
  final isSpeaking = false.obs;
  final userQuestion = ''.obs;
  final aiResponse = ''.obs;
  final isListening = false.obs;

  // Bidirectional AI conversation state
  final isConversationActive = false.obs;
  final isSettingUpSession = false.obs;
  final conversationText = ''.obs;
  final conversationHistory = <ConversationMessage>[].obs;

  // Timer for periodic image capture
  Timer? _captureTimer;

  @override
  void onInit() {
    super.onInit();
    initializeServices();
    _setupBidirectionalAICallbacks();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _captureTimer?.cancel();
    super.onClose();
  }

  void _setupBidirectionalAICallbacks() {
    _bidirectionalAIService.onTextReceived = (text) {
      conversationText.value = text;
      aiResponse.value = text;

      // Add AI message to conversation history
      final aiMessage = ConversationMessage.ai(content: text);
      conversationHistory.add(aiMessage);
    };

    _bidirectionalAIService.onError = (error) {
      print('Bidirectional AI Error: $error');
      aiResponse.value = 'Sorry, there was an error with the conversation.';

      // Add error message to conversation history
      final errorMessage = ConversationMessage.system(
        content: 'Error: $error',
        status: MessageStatus.error,
      );
      conversationHistory.add(errorMessage);
    };

    _bidirectionalAIService.onConversationStarted = () {
      isConversationActive.value = true;
      isVoiceRecognitionActive.value = true;
      userQuestion.value = 'Listening...';

      // Add system message to conversation history
      final systemMessage = ConversationMessage.system(
        content: 'Conversation started',
      );
      conversationHistory.add(systemMessage);
    };

    _bidirectionalAIService.onConversationStopped = () {
      isConversationActive.value = false;
      isVoiceRecognitionActive.value = false;
      userQuestion.value = '';

      // Add system message to conversation history
      final systemMessage = ConversationMessage.system(
        content: 'Conversation ended',
      );
      conversationHistory.add(systemMessage);
    };
  }

  Future<void> initializeServices() async {
    try {
      // Initialize camera
      await initializeCamera();
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  Future<void> initializeCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status.isGranted) {
        cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // Find front camera (selfie camera)
          final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

          cameraController = CameraController(
            frontCamera,
            ResolutionPreset.high,
            enableAudio: false,
          );
          await cameraController!.initialize();
          isCameraInitialized.value = true;
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void toggleCamera() {
    if (isCameraActive.value) {
      stopCamera();
    } else {
      startCamera();
    }
  }

  void startCamera() {
    if (isCameraInitialized.value && cameraController != null) {
      isCameraActive.value = true;
      startPeriodicCapture();
    }
  }

  void stopCamera() {
    isCameraActive.value = false;
    stopPeriodicCapture();
  }

  void startPeriodicCapture() {
    _captureTimer?.cancel();
    _captureTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isCameraActive.value && !isProcessing.value) {
        captureAndProcessImage();
      }
    });
  }

  void stopPeriodicCapture() {
    _captureTimer?.cancel();
  }

  Future<void> captureAndProcessImage() async {
    if (cameraController == null || !isCameraInitialized.value) return;

    try {
      isProcessing.value = true;

      // Capture image
      final XFile image = await cameraController!.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

      // Process with AI if there's a user question
      if (userQuestion.value.isNotEmpty &&
          userQuestion.value != 'Listening...') {
        final response = await _aiService.processImageAndText(
          imageBytes: imageBytes,
          userQuestion: userQuestion.value,
        );

        aiResponse.value = response;

        // Log interaction
        await _firebaseService.logInteraction(
          userQuestion: userQuestion.value,
          aiResponse: response,
          hasImage: true,
        );

        // Clear user question after processing
        userQuestion.value = '';
      }
    } catch (e) {
      print('Error capturing and processing image: $e');
      await _firebaseService.logError(
        error: e.toString(),
        context: 'captureAndProcessImage',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void toggleVoiceRecognition() {
    if (isConversationActive.value) {
      stopVoiceRecognition();
    } else {
      startVoiceRecognition();
    }
  }

  void startVoiceRecognition() {
    _bidirectionalAIService.startConversation();
  }

  void stopVoiceRecognition() {
    _bidirectionalAIService.stopConversation();
  }

  Future<void> processUserQuestion() async {
    if (userQuestion.value.isEmpty || userQuestion.value == 'Listening...')
      return;

    try {
      isProcessing.value = true;

      String response;
      if (isCameraActive.value && cameraController != null) {
        // Capture current image and process with vision
        final XFile image = await cameraController!.takePicture();
        final Uint8List imageBytes = await image.readAsBytes();

        response = await _aiService.processImageAndText(
          imageBytes: imageBytes,
          userQuestion: userQuestion.value,
        );
      } else {
        // Process text only
        response = await _aiService.processTextOnly(userQuestion.value);
      }

      aiResponse.value = response;

      // Log interaction
      await _firebaseService.logInteraction(
        userQuestion: userQuestion.value,
        aiResponse: response,
        hasImage: isCameraActive.value,
      );
    } catch (e) {
      print('Error processing user question: $e');
      aiResponse.value = 'Sorry, there was an error processing your request.';
      await _firebaseService.logError(
        error: e.toString(),
        context: 'processUserQuestion',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void cancelAction() {
    isCameraActive.value = false;
    isVoiceRecognitionActive.value = false;
    isRecording.value = false;
    stopVoiceRecognition();
    userQuestion.value = '';
    aiResponse.value = '';
    conversationText.value = '';
    conversationHistory.clear();
  }

  void confirmAction() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  void startRecording() {
    if (isCameraActive.value) {
      isRecording.value = true;
      startVoiceRecognition();
    }
  }

  void stopRecording() {
    isRecording.value = false;
    stopVoiceRecognition();
  }

  // Getters for UI
  bool get isBidirectionalAIReady => _bidirectionalAIService.isReady;
  bool get isBidirectionalAIActive => _bidirectionalAIService.isActive;
  bool get isBidirectionalAISettingUp => _bidirectionalAIService.isSettingUp;
}
