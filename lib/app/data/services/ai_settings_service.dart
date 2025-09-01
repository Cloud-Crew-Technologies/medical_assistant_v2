import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AISettingsService extends GetxService {
  static const String _voiceKey = 'ai_voice_name';
  static const String _modelKey = 'ai_model_name';
  static const String _sampleRateKey = 'ai_sample_rate';
  static const String _autoStartKey = 'ai_auto_start';
  static const String _saveHistoryKey = 'ai_save_history';

  // Observable settings
  final voiceName = 'fenrir'.obs;
  final modelName = 'gemini-2.0-flash-live-preview-04-09'.obs;
  final sampleRate = 24000.obs;
  final autoStartConversation = false.obs;
  final saveConversationHistory = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      voiceName.value = prefs.getString(_voiceKey) ?? 'fenrir';
      modelName.value =
          prefs.getString(_modelKey) ?? 'gemini-2.0-flash-live-preview-04-09';
      sampleRate.value = prefs.getInt(_sampleRateKey) ?? 24000;
      autoStartConversation.value = prefs.getBool(_autoStartKey) ?? false;
      saveConversationHistory.value = prefs.getBool(_saveHistoryKey) ?? true;
    } catch (e) {
      print('Error loading AI settings: $e');
    }
  }

  Future<void> setVoiceName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_voiceKey, name);
      voiceName.value = name;
    } catch (e) {
      print('Error saving voice name: $e');
    }
  }

  Future<void> setModelName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_modelKey, name);
      modelName.value = name;
    } catch (e) {
      print('Error saving model name: $e');
    }
  }

  Future<void> setSampleRate(int rate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_sampleRateKey, rate);
      sampleRate.value = rate;
    } catch (e) {
      print('Error saving sample rate: $e');
    }
  }

  Future<void> setAutoStartConversation(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoStartKey, value);
      autoStartConversation.value = value;
    } catch (e) {
      print('Error saving auto start setting: $e');
    }
  }

  Future<void> setSaveConversationHistory(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_saveHistoryKey, value);
      saveConversationHistory.value = value;
    } catch (e) {
      print('Error saving history setting: $e');
    }
  }

  // Available voice options
  List<String> get availableVoices => [
    'fenrir',
    'alloy',
    'echo',
    'fable',
    'onyx',
    'nova',
    'shimmer',
  ];

  // Available model options
  List<String> get availableModels => [
    'gemini-2.0-flash-live-preview-04-09',
    'gemini-1.5-flash-live-preview-04-09',
  ];

  // Available sample rates
  List<int> get availableSampleRates => [16000, 24000, 32000, 44100, 48000];

  // Reset to defaults
  Future<void> resetToDefaults() async {
    await setVoiceName('fenrir');
    await setModelName('gemini-2.0-flash-live-preview-04-09');
    await setSampleRate(24000);
    await setAutoStartConversation(false);
    await setSaveConversationHistory(true);
  }
}
