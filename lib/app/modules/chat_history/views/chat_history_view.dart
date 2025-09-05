import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_history_controller.dart';

class ChatHistoryView extends GetView<ChatHistoryController> {
  const ChatHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChatHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
