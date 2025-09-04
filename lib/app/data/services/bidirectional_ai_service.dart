// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:firebase_ai/firebase_ai.dart';
// import 'package:record/record.dart';
// import 'package:flutter_soloud/flutter_soloud.dart';
// import 'package:get/get.dart';
// import 'ai_settings_service.dart';

// class BidirectionalAIService extends GetxService {
//   // Services
//   final AISettingsService _settingsService = Get.find<AISettingsService>();

//   // Firebase AI Live components
//   late LiveGenerativeModel _liveModel;
//   LiveSession? _session;

//   // Audio components
//   final AudioRecorder _recorder = AudioRecorder();
//   Stream<Uint8List>? _inputStream;
//   StreamController<bool> _stopController = StreamController<bool>();

//   // State management
//   final isSessionOpened = false.obs;
//   final isSettingUpSession = false.obs;
//   final isConversationActive = false.obs;
//   final isAudioReady = false.obs;
//   final isRecording = false.obs;

//   // Callbacks
//   Function(String)? onTextReceived;
//   Function(String)? onError;
//   Function()? onConversationStarted;
//   Function()? onConversationStopped;

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeLiveModel();
//   }

//   @override
//   void onClose() {
//     _recorder.dispose();
//     _stopController.close();
//     _session?.close();
//     super.onClose();
//   }

//   void _initializeLiveModel() {
//     _liveModel = FirebaseAI.vertexAI().liveGenerativeModel(
//       systemInstruction: Content.text('''
//         You are Dr. Nightingale AI, a friendly and knowledgeable medical assistant. 
//         Your role is to help users with medical questions, provide health advice, 
//         and assist with general wellness information. Always be professional, 
//         empathetic, and clear in your responses. If a user asks about serious 
//         medical symptoms, recommend consulting a healthcare professional.
        
//         Key guidelines:
//         - Provide accurate, evidence-based medical information
//         - Be empathetic and supportive
//         - Encourage professional medical consultation for serious concerns
//         - Use clear, understandable language
//         - Maintain patient confidentiality
//       '''),
//       model: _settingsService.modelName.value,
//       liveGenerationConfig: LiveGenerationConfig(
//         speechConfig: SpeechConfig(voiceName: _settingsService.voiceName.value),
//         responseModalities: [ResponseModalities.audio],
//       ),
//     );
//   }

//   Future<void> initializeAudio() async {
//     try {
//       await _checkMicrophonePermission();
//       await SoLoud.instance.init(
//         sampleRate: _settingsService.sampleRate.value,
//         channels: Channels.mono,
//       );
//       isAudioReady.value = true;
//       log('Audio initialized successfully');
//     } catch (e) {
//       log('Error initializing audio: $e');
//       onError?.call('Failed to initialize audio: $e');
//     }
//   }

//   Future<void> _checkMicrophonePermission() async {
//     final hasPermission = await _recorder.hasPermission();
//     if (!hasPermission) {
//       throw Exception('Microphone permission not granted');
//     }
//   }

//   Future<void> startConversation() async {
//     if (!isAudioReady.value) {
//       await initializeAudio();
//     }

//     try {
//       isSettingUpSession.value = true;

//       // Start the live session
//       await _toggleLiveGeminiSession();

//       // Start recording audio input stream
//       _inputStream = await _startRecordingStream();
//       log('Input stream started');

//       // Send audio stream to Gemini
//       Stream<InlineDataPart> inlineDataStream = _inputStream!.map((data) {
//         return InlineDataPart('audio/pcm', data);
//       });
//       _session?.sendMediaStream(inlineDataStream);

//       isConversationActive.value = true;
//       isSettingUpSession.value = false;
//       onConversationStarted?.call();
//     } catch (e) {
//       log('Error starting conversation: $e');
//       isSettingUpSession.value = false;
//       onError?.call('Failed to start conversation: $e');
//     }
//   }

//   Future<void> stopConversation() async {
//     try {
//       // Stop recording input audio
//       await _stopRecording();

//       // End the live session
//       await _toggleLiveGeminiSession();

//       isConversationActive.value = false;
//       onConversationStopped?.call();
//     } catch (e) {
//       log('Error stopping conversation: $e');
//       onError?.call('Failed to stop conversation: $e');
//     }
//   }

//   Future<void> _toggleLiveGeminiSession() async {
//     isSettingUpSession.value = true;

//     if (!isSessionOpened.value) {
//       _session = await _liveModel.connect();
//       isSessionOpened.value = true;
//       _processMessagesContinuously();
//     } else {
//       await _session?.close();
//       _stopController.add(true);
//       await _stopController.close();
//       _stopController = StreamController<bool>();
//       isSessionOpened.value = false;
//     }

//     isSettingUpSession.value = false;
//   }

//   Future<void> _processMessagesContinuously() async {
//     bool shouldContinue = true;

//     _stopController.stream.listen((stop) {
//       if (stop) {
//         shouldContinue = false;
//       }
//     });

//     while (shouldContinue && _session != null) {
//       try {
//         await for (final response in _session!.receive()) {
//           await _handleLiveServerMessage(response);
//         }
//       } catch (e) {
//         log('Error processing messages: $e');
//         break;
//       }
//     }
//   }

//   Future<void> _handleLiveServerMessage(dynamic response) async {
//     if (response is LiveServerContent) {
//       if (response.modelTurn != null) {
//         await _handleLiveServerContent(response);
//       }
//       if (response.turnComplete != null && response.turnComplete!) {
//         await _handleTurnComplete();
//       }
//       if (response.interrupted != null && response.interrupted!) {
//         log('Interrupted: $response');
//       }
//     }
//   }

//   Future<void> _handleLiveServerContent(LiveServerContent response) async {
//     final partList = response.modelTurn?.parts;
//     if (partList != null) {
//       for (final part in partList) {
//         if (part is TextPart) {
//           await _handleTextPart(part);
//         } else if (part is InlineDataPart) {
//           await _handleInlineDataPart(part);
//         } else {
//           log('Received part with type ${part.runtimeType}');
//         }
//       }
//     }
//   }

//   Future<void> _handleTextPart(TextPart part) async {
//     log('Text message from Gemini: ${part.text}');
//     onTextReceived?.call(part.text);
//   }

//   Future<void> _handleInlineDataPart(InlineDataPart part) async {
//     if (part.mimeType.startsWith('audio')) {
//       log('Received audio data: ${part.bytes.length} bytes');
//       // Audio output will be handled by Firebase AI automatically
//     }
//   }

//   Future<void> _handleTurnComplete() async {
//     log('Model turn complete');
//   }

//   Future<Stream<Uint8List>> _startRecordingStream() async {
//     final recordConfig = RecordConfig(
//       encoder: AudioEncoder.pcm16bits,
//       sampleRate: _settingsService.sampleRate.value,
//       numChannels: 1,
//       echoCancel: true,
//       noiseSuppress: true,
//       androidConfig: AndroidRecordConfig(
//         audioSource: AndroidAudioSource.voiceCommunication,
//       ),
//       iosConfig: IosRecordConfig(
//         categoryOptions: [IosAudioCategoryOption.defaultToSpeaker],
//       ),
//     );

//     isRecording.value = true;
//     return await _recorder.startStream(recordConfig);
//   }

//   Future<void> _stopRecording() async {
//     await _recorder.stop();
//     isRecording.value = false;
//   }

//   void toggleConversation() {
//     if (isConversationActive.value) {
//       stopConversation();
//     } else {
//       startConversation();
//     }
//   }

//   // Getters for UI
//   bool get isReady => isAudioReady.value;
//   bool get isActive => isConversationActive.value;
//   bool get isSettingUp => isSettingUpSession.value;
// }
