import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/home_controller.dart';
import 'package:livekit_client/livekit_client.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: Center(child: JoinButton()),
    );
  }
}

class JoinButton extends StatelessWidget {
  Future<void> joinRoom() async {
    // Request permissions
    await [Permission.camera, Permission.microphone].request();

    // Replace with your server’s token endpoint
    final token = "<YOUR_ACCESS_TOKEN>";

    final room = Room();
    room.addListener(() {
      print("Room changed: ${room.name}");
    });

    await room.connect("wss://your-livekit-server:7880", token);

    // Publish camera + mic
    await room.localParticipant?.setCameraEnabled(true);
    await room.localParticipant?.setMicrophoneEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: joinRoom, child: const Text("Join Room"));
  }
}
