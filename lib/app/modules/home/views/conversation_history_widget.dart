import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/conversation_message.dart';
import '../../../theme/theme_data.dart';

class ConversationHistoryWidget extends StatelessWidget {
  final List<ConversationMessage> messages;
  final ScrollController? scrollController;

  const ConversationHistoryWidget({
    super.key,
    required this.messages,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGlowingTealColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: kGlowingTealColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Conversation History',
                style: TextStyle(
                  color: kGlowingTealColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${messages.length} messages',
                style: TextStyle(
                  color: kFontColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (messages.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: kFontColor.withOpacity(0.5),
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No conversation yet',
                      style: TextStyle(
                        color: kFontColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start a conversation to see messages here',
                      style: TextStyle(
                        color: kFontColor.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageItem(message);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ConversationMessage message) {
    final isUser = message.type == MessageType.user;
    final isAI = message.type == MessageType.ai;
    final isSystem = message.type == MessageType.system;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getMessageColor(message.type),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getMessageIcon(message.type),
              color: kWhiteTextColor,
              size: 12,
            ),
          ),
          const SizedBox(width: 8),
          // Message content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getMessageBackgroundColor(message.type),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getMessageColor(message.type).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getMessageLabel(message.type),
                        style: TextStyle(
                          color: _getMessageColor(message.type),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: kFontColor.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: kWhiteTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (message.status == MessageStatus.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Error occurred',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.user:
        return kGlowingBlueColor;
      case MessageType.ai:
        return kGlowingTealColor;
      case MessageType.system:
        return kFontColor;
    }
  }

  Color _getMessageBackgroundColor(MessageType type) {
    switch (type) {
      case MessageType.user:
        return kGlowingBlueColor.withOpacity(0.1);
      case MessageType.ai:
        return kGlowingTealColor.withOpacity(0.1);
      case MessageType.system:
        return kDarkSlateButtonColor;
    }
  }

  IconData _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.user:
        return Icons.person;
      case MessageType.ai:
        return Icons.smart_toy;
      case MessageType.system:
        return Icons.info;
    }
  }

  String _getMessageLabel(MessageType type) {
    switch (type) {
      case MessageType.user:
        return 'You';
      case MessageType.ai:
        return 'Dr. Nightingale AI';
      case MessageType.system:
        return 'System';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
