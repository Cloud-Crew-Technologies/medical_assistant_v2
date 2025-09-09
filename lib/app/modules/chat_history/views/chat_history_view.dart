import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_assistant_v2/app/routes/app_pages.dart';
// import 'package:medical_assistant_v2/app/routes/app_pages.dart';
// import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import '../controllers/chat_history_controller.dart';

class ChatHistoryView extends GetView<ChatHistoryController> {
  const ChatHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C9185), // Teal green at top
              Color(0xFF2CD3BE), // Lighter teal
            ],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header with gradient background
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Top navigation row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My AI Chats",
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tab buttons (Recent and Trash)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.setActiveTab('recent'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.activeTab.value == 'recent'
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Recent',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: controller.activeTab.value == 'recent'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.setActiveTab('trash'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: controller.activeTab.value == 'trash'
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Trash',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: controller.activeTab.value == 'trash'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),

              // White content area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: TextField(
                          onChanged: controller.updateSearchQuery,
                          decoration: InputDecoration(
                            hintText: 'Search AI Conversation...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                            suffixIcon: Icon(Icons.mic, color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFF0C9185)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      // Section header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                              controller.activeTab.value == 'recent' 
                                  ? 'Recent (${controller.filteredChatSessions.length})'
                                  : 'Trash (${controller.trashedSessions.length})',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            )),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.CHAT_SCREEN);
                              }, // Navigate to see all
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chat History List
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0C9185),
                                ),
                              ),
                            );
                          }

                          final sessions = controller.activeTab.value == 'recent'
                              ? controller.filteredChatSessions
                              : controller.trashedSessions;

                          if (sessions.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    controller.activeTab.value == 'recent'
                                        ? (controller.searchQuery.value.isEmpty
                                            ? 'No chat history found'
                                            : 'No chats match your search')
                                        : 'Trash is empty',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.activeTab.value == 'recent'
                                        ? (controller.searchQuery.value.isEmpty
                                            ? 'Start a new conversation to see your chat history here'
                                            : 'Try searching with different keywords')
                                        : 'Deleted chats will appear here',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: controller.refreshChatHistory,
                            color: const Color(0xFF0C9185),
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              itemCount: sessions.length,
                              itemBuilder: (context, index) {
                                final session = sessions[index];
                                return _buildEnhancedChatSessionCard(session, context);
                              },
                            ),
                          );
                        }),
                      ),
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

  Widget _buildEnhancedChatSessionCard(ChatSession session, BuildContext context) {
    // Get appropriate icon based on session type
    IconData getSessionIcon() {
      final title = session.title.toLowerCase();
      if (title.contains('stomach') || title.contains('pain')) {
        return Icons.healing;
      } else if (title.contains('eye') || title.contains('vision')) {
        return Icons.visibility;
      } else if (title.contains('knee') || title.contains('joint')) {
        return Icons.sports_gymnastics;
      } else if (title.contains('diabetes') || title.contains('blood')) {
        return Icons.water_drop;
      }
      return Icons.chat_bubble_outline;
    }

    Color getIconColor() {
      final title = session.title.toLowerCase();
      if (title.contains('stomach') || title.contains('pain')) {
        return const Color(0xFF4A90E2);
      } else if (title.contains('eye') || title.contains('vision')) {
        return const Color(0xFF50C878);
      } else if (title.contains('knee') || title.contains('joint')) {
        return const Color(0xFFFF6B6B);
      } else if (title.contains('diabetes') || title.contains('blood')) {
        return const Color(0xFF4ECDC4);
      }
      return const Color(0xFF0C9185);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: InkWell(
        onTap: () => controller.openChatSession(session),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Icon instead of avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getIconColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                getSessionIcon(),
                color: getIconColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Chat Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chat Title
                  Text(
                    session.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Stats Row
                  Row(
                    children: [
                      // Message count
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${session.messages.length}Total',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Heart rate or other metric (mock data)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite, size: 14, color: Colors.red[400]),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${(70 + (session.id.hashCode % 50)).abs()}bpm',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Time
                      Text(
                        controller.formatTime(session.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // More Options Menu
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(session, context);
                } else if (value == 'open') {
                  controller.openChatSession(session);
                } else if (value == 'restore') {
                  controller.restoreChatSession(session.id);
                }
              },
              itemBuilder: (context) {
                if (controller.activeTab.value == 'trash') {
                  return [
                    const PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [
                          Icon(Icons.restore, size: 18, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Restore'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete Forever'),
                        ],
                      ),
                    ),
                  ];
                }
                
                return [
                  const PopupMenuItem(
                    value: 'open',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new, size: 18, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Open Chat'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Move to Trash'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ChatSession session, BuildContext context) {
    final isTrash = controller.activeTab.value == 'trash';
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isTrash ? 'Delete Forever' : 'Move to Trash'),
        content: Text(
          isTrash 
            ? 'Are you sure you want to permanently delete "${session.title}"? This action cannot be undone.'
            : 'Are you sure you want to move "${session.title}" to trash?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isTrash) {
                controller.deleteChatSessionPermanently(session.id);
              } else {
                controller.moveChatSessionToTrash(session.id);
              }
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(isTrash ? 'Delete Forever' : 'Move to Trash'),
          ),
        ],
      ),
    );
  }
}