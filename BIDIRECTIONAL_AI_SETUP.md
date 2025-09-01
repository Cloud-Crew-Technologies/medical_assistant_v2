# 🌟 Bidirectional AI Conversation Setup Guide

This guide will help you set up and use the bidirectional AI conversation feature in your medical assistant app.

## 🚀 Features Implemented

### 1. **Bidirectional AI Conversation**
- Real-time voice conversation with Dr. Nightingale AI
- Firebase AI Live integration with Gemini 2.0 Flash
- Automatic speech-to-text and text-to-speech
- Live conversation history tracking

### 2. **Advanced UI Components**
- Dynamic voice recognition indicators
- Real-time conversation status
- Conversation history widget
- Loading states and error handling

### 3. **Configuration Management**
- AI voice selection (fenrir, alloy, echo, etc.)
- Model selection (Gemini 2.0 Flash, Gemini 1.5 Flash)
- Sample rate configuration
- Auto-start conversation settings

## 📋 Prerequisites

### Required Dependencies
Make sure these dependencies are in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2
  firebase_ai: ^3.0.0
  record: ^5.0.4
  flutter_soloud: ^2.0.0
  shared_preferences: ^2.2.2
  camera: ^0.10.5+9
  permission_handler: ^11.3.1
  firebase_core: ^4.0.0
  cloud_firestore: ^6.0.0
  google_generative_ai: ^0.4.0
  flutter_tts: ^3.8.5
  http: ^1.2.0
  path_provider: ^2.1.2
  image: ^4.1.7
  google_fonts: ^6.3.0
```

### Firebase Setup
1. **Firebase Project**: Ensure you have a Firebase project set up
2. **Firebase AI**: Enable Firebase AI in your project
3. **API Keys**: Configure your Firebase API keys in `firebase_options.dart`

## 🔧 Installation Steps

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Configure Firebase
1. Add your Firebase configuration to `lib/firebase_options.dart`
2. Ensure Firebase AI is enabled in your Firebase console

### Step 3: Platform Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)
Add these permissions:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (`ios/Runner/Info.plist`)
Add these permissions:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice conversations</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for medical assistance</string>
```

## 🎯 Usage Guide

### Starting a Conversation
1. **Tap the microphone button** in the center of the home screen
2. **Wait for setup** - The app will initialize the AI session
3. **Start speaking** - Your voice will be processed in real-time
4. **Listen to responses** - Dr. Nightingale AI will respond with voice and text

### Conversation Controls
- **Microphone Button**: Start/stop conversation
- **Cancel Button (X)**: End conversation and clear history
- **Confirm Button (✓)**: Confirm actions (when applicable)

### Conversation History
- **Real-time Updates**: See messages as they happen
- **Message Types**: User, AI, and System messages
- **Timestamps**: Each message shows when it was sent
- **Error Handling**: Failed messages are clearly marked

## 🔧 Configuration Options

### AI Voice Settings
The app supports multiple AI voices:
- `fenrir` (default) - Professional and clear
- `alloy` - Warm and friendly
- `echo` - Natural and conversational
- `fable` - Storytelling voice
- `onyx` - Deep and authoritative
- `nova` - Bright and energetic
- `shimmer` - Soft and gentle

### Model Selection
- **Gemini 2.0 Flash** (default) - Latest and most capable
- **Gemini 1.5 Flash** - Alternative option

### Audio Settings
- **Sample Rates**: 16kHz, 24kHz, 32kHz, 44.1kHz, 48kHz
- **Channels**: Mono (optimized for voice)
- **Noise Suppression**: Enabled by default
- **Echo Cancellation**: Enabled by default

## 🏗️ Architecture Overview

### Core Components

#### 1. **BidirectionalAIService** (`lib/app/data/services/bidirectional_ai_service.dart`)
- Manages Firebase AI Live sessions
- Handles audio input/output streams
- Provides conversation state management
- Implements error handling and recovery

#### 2. **HomeController** (`lib/app/modules/home/controllers/home_controller.dart`)
- Integrates bidirectional AI with existing functionality
- Manages conversation history
- Handles UI state updates
- Coordinates between different services

#### 3. **AISettingsService** (`lib/app/data/services/ai_settings_service.dart`)
- Manages AI configuration settings
- Persists settings using SharedPreferences
- Provides default configurations
- Handles settings validation

#### 4. **ConversationMessage** (`lib/app/modules/home/models/conversation_message.dart`)
- Data model for conversation messages
- Supports different message types (user, AI, system)
- Includes status tracking and error handling
- Provides JSON serialization

### UI Components

#### 1. **HomeView** (`lib/app/modules/home/views/home_view.dart`)
- Main conversation interface
- Dynamic voice recognition indicators
- Real-time status updates
- Responsive design for different states

#### 2. **ConversationHistoryWidget** (`lib/app/modules/home/views/conversation_history_widget.dart`)
- Displays conversation history
- Message type differentiation
- Timestamp formatting
- Error state handling

## 🐛 Troubleshooting

### Common Issues

#### 1. **Microphone Permission Denied**
```
Error: Microphone permission not granted
```
**Solution**: 
- Check app permissions in device settings
- Ensure microphone permission is granted
- Restart the app after granting permissions

#### 2. **Firebase AI Connection Failed**
```
Error: Failed to start conversation
```
**Solution**:
- Verify Firebase project configuration
- Check internet connection
- Ensure Firebase AI is enabled in console
- Verify API keys are correct

#### 3. **Audio Initialization Failed**
```
Error: Failed to initialize audio
```
**Solution**:
- Check device audio settings
- Ensure no other apps are using microphone
- Restart the app
- Check device compatibility

#### 4. **High Latency in Conversation**
**Solution**:
- Reduce sample rate to 16kHz or 24kHz
- Check internet connection speed
- Close other resource-intensive apps
- Use a different AI model if available

### Debug Mode
Enable debug logging by adding this to your main.dart:
```dart
void main() {
  runApp(MyApp());
  // Enable debug logging
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      print('DEBUG: $message');
    }
  };
}
```

## 📱 Testing

### Manual Testing Checklist
- [ ] Microphone permission granted
- [ ] Firebase AI connection established
- [ ] Audio input/output working
- [ ] Conversation history updating
- [ ] Error handling working
- [ ] Settings persistence working
- [ ] UI responsiveness during conversation
- [ ] Background/foreground app switching

### Automated Testing
Run the test suite:
```bash
flutter test
```

## 🔄 Updates and Maintenance

### Regular Maintenance
1. **Update Dependencies**: Keep Firebase AI and other packages updated
2. **Monitor API Usage**: Track Firebase AI usage and costs
3. **Performance Monitoring**: Monitor conversation latency and quality
4. **User Feedback**: Collect and address user feedback

### Future Enhancements
- [ ] Multi-language support
- [ ] Custom AI personalities
- [ ] Conversation export
- [ ] Offline mode
- [ ] Advanced audio processing
- [ ] Integration with health records

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Firebase AI documentation
3. Check Flutter and package documentation
4. Create an issue in the project repository

## 📄 License

This implementation follows the same license as your main project.

---

**Note**: This bidirectional AI conversation feature is designed to work seamlessly with your existing medical assistant app. The implementation uses GetX for state management and follows Flutter best practices for performance and user experience.
