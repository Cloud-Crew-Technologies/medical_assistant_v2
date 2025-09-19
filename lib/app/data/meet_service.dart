import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:medical_assistant_v2/app/modules/meet/pages/prejoin.dart';
import 'package:medical_assistant_v2/app/modules/meet/pages/room.dart';
import 'package:medical_assistant_v2/app/modules/meet/exts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_service.dart';

class MeetService {
  static const String serverUrl = 'wss://ash10-n1k1vc5v.livekit.cloud';

  static Future<void> connectDirectlyToRoom(BuildContext context) async {
    try {
      // Check permissions first
      if (lkPlatformIs(PlatformType.android)) {
        await _checkPermissions();
      }

      // Get token from API
      final token = await ApiService.getToken();

      // Check if context is still mounted
      if (!context.mounted) return;

      // Create JoinArgs with specified settings
      final args = JoinArgs(
        url: serverUrl,
        token: token,
        e2ee: false, // E2EE turn off
        simulcast: true, // Simulcast on
        adaptiveStream: true, // Adaptive stream on
        dynacast: true, // Dynacast on
        preferredCodec: 'VP8', // Multi codec off (using VP8 only)
        enableBackupVideoCodec: false, // Multi codec off
      );

      // Connect directly to room
      await _joinRoom(context, args);
    } catch (error) {
      if (context.mounted) {
        await context.showErrorDialog(error);
      }
    }
  }

  static Future<void> _checkPermissions() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      status = await Permission.microphone.status;
      if (status.isGranted) {
        return;
      }
    }

    if (status.isDenied) {
      final res = await [Permission.camera, Permission.microphone].request();
      if (res[Permission.camera] != PermissionStatus.granted ||
          res[Permission.microphone] != PermissionStatus.granted) {
        throw Exception('Camera and Microphone permissions are required');
      }
    }
  }

  static Future<void> _joinRoom(BuildContext context, JoinArgs args) async {
    try {
      // Create room with specified settings
      var cameraEncoding = const VideoEncoding(
        maxBitrate: 5 * 1000 * 1000,
        maxFramerate: 30,
      );

      var screenEncoding = const VideoEncoding(
        maxBitrate: 3 * 1000 * 1000,
        maxFramerate: 15,
      );

      E2EEOptions? e2eeOptions;
      if (args.e2ee && args.e2eeKey != null) {
        final keyProvider = await BaseKeyProvider.create();
        e2eeOptions = E2EEOptions(keyProvider: keyProvider);
        await keyProvider.setKey(args.e2eeKey!);
      }

      final room = Room(
        roomOptions: RoomOptions(
          adaptiveStream: args.adaptiveStream,
          dynacast: args.dynacast,
          defaultAudioPublishOptions: const AudioPublishOptions(
            name: 'custom_audio_track_name',
          ),
          defaultCameraCaptureOptions: const CameraCaptureOptions(
            maxFrameRate: 30,
            params: VideoParameters(dimensions: VideoDimensions(1280, 720)),
          ),
          defaultScreenShareCaptureOptions: const ScreenShareCaptureOptions(
            useiOSBroadcastExtension: true,
            params: VideoParameters(
              dimensions: VideoDimensionsPresets.h1080_169,
            ),
          ),
          defaultVideoPublishOptions: VideoPublishOptions(
            simulcast: args.simulcast,
            videoCodec: args.preferredCodec,
            backupVideoCodec: BackupVideoCodec(
              enabled: args.enableBackupVideoCodec,
            ),
            videoEncoding: cameraEncoding,
            screenShareEncoding: screenEncoding,
          ),
          e2eeOptions: e2eeOptions,
        ),
      );

      // Create a Listener before connecting
      final listener = room.createListener();

      await room.prepareConnection(args.url, args.token);

      // Try to connect to the room
      await room.connect(args.url, args.token);

      // Navigate to room page
      if (context.mounted) {
        await Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (_) => RoomPage(room, listener)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        await context.showErrorDialog(error);
      }
    }
  }
}
