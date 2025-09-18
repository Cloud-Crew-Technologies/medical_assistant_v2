import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_assistant_v2/app/modules/chat_history/models/chat_history_model.dart';
import 'package:medical_assistant_v2/app/routes/app_pages.dart';
import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import '../controllers/chat_history_controller.dart';

class ChatHistoryView extends GetView<ChatHistoryController> {
  const ChatHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        // 🌙 Gradient background updated
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [kDarkPrimaryBg, kDarkSecondaryBg]
                : [kLightGradientStart, kLightGradientEnd],
            stops: const [0.0, 0.6],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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

                    // Tab buttons
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Obx(
                        () => Row(
                          children: [
                            _buildTabButton('recent'),
                            _buildTabButton('trash'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? kDarkTextFieldBg : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),

                  child: Column(
                    children: [
                      // Search Bar
                      _buildSearchBar(isDark),

                      // Section Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                controller.activeTab.value == 'recent'
                                    ? 'Recent (${controller.filteredChatSessions.length})'
                                    : 'Trash (${controller.trashedSessions.length})',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? kWhiteTextColor
                                      : kLightLargeFontColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed(Routes.CHAT_SCREEN),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : kLightSmallFontColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Chat History
                      Expanded(child: _buildChatHistory(isDark)),
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

  // 🔹 Tab Button Builder
  Widget _buildTabButton(String tab) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setActiveTab(tab),
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: controller.activeTab.value == tab
                  ? Colors.white.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tab.capitalize!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: controller.activeTab.value == tab
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Search Bar
  Widget _buildSearchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search AI Conversation...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : kLightSmallFontColor,
          ),
          prefixIcon: const Icon(Icons.search, color: kNewTealColor),
          suffixIcon: Icon(
            Icons.mic,
            color: isDark ? Colors.grey[300] : kLightSmallFontColor,
          ),
          filled: true,
          fillColor: isDark ? kDarkCardBg : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDark ? kDarkSecondaryBg : Colors.grey[200]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDark ? kDarkSecondaryBg : Colors.grey[200]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: kNewTealColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // 🔹 Chat History Builder
  Widget _buildChatHistory(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? kNewTealColor : kLightButtonColor,
            ),
          ),
        );
      }

      final sessions = controller.activeTab.value == 'recent'
          ? controller.filteredChatSessions
          : controller.trashedSessions;

      if (sessions.isEmpty) {
        return _buildEmptyState(isDark);
      }

      return RefreshIndicator(
        onRefresh: controller.refreshChatHistory,
        color: kLightGradientStart,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return _buildEnhancedChatSessionCard(sessions[index], context);
          },
        ),
      );
    });
  }

  // 🔹 Empty State
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
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
              color: isDark ? Colors.grey[400] : Colors.grey[600],
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
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🔹 Chat Session Card
  Widget _buildEnhancedChatSessionCard(
    ChatSession session,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        return kBlueIconColor;
      } else if (title.contains('eye') || title.contains('vision')) {
        return kGreenIconColor;
      } else if (title.contains('knee') || title.contains('joint')) {
        return kRedIconColor;
      } else if (title.contains('diabetes') || title.contains('blood')) {
        return kCyanIconColor;
      }
      return kDefaultIconColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kDarkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
        border: Border.all(
          color: isDark ? kDarkSecondaryBg : Colors.grey[100]!,
        ),
      ),

      child: InkWell(
        onTap: () => controller.openChatSession(session),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getIconColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(getSessionIcon(), color: getIconColor(), size: 24),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? kWhiteTextColor : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? kDarkSecondaryBg
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 14,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${session.messages.length} Total',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[600],
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

                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 14,
                                color: Colors.red[400],
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${(70 + (session.id.hashCode % 50)).abs()} bpm',
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

                      Text(
                        controller.formatTime(session.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? Colors.grey[400] : Colors.grey[400],
                size: 20,
              ),
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
                          Icon(
                            Icons.delete_forever,
                            size: 18,
                            color: Colors.red,
                          ),
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? kDarkCardBg
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isTrash ? 'Delete Forever' : 'Move to Trash'),
        content: Text(
          isTrash
              ? 'Are you sure you want to permanently delete "${session.title}"?'
              : 'Are you sure you want to move "${session.title}" to trash?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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
