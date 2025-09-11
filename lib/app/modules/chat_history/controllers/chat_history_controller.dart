import 'package:get/get.dart';
import 'package:medical_assistant_v2/app/modules/chat_history/models/chat_history_model.dart';
// import 'package:medical_assistant_v2/app/routes/app_pages.dart';

class ChatHistoryController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final activeTab = 'recent'.obs;
  
  // Chat sessions lists
  final RxList<ChatSession> _allChatSessions = <ChatSession>[].obs;
  final RxList<ChatSession> _trashedSessions = <ChatSession>[].obs;

  // Getters
  List<ChatSession> get allChatSessions => _allChatSessions;
  List<ChatSession> get trashedSessions => _trashedSessions;
  
  List<ChatSession> get filteredChatSessions {
    if (searchQuery.value.isEmpty) {
      return _allChatSessions.where((session) => !session.isTrashed).toList();
    }
    return _allChatSessions
        .where((session) => 
            !session.isTrashed &&
            (session.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
             session.lastMessage.toLowerCase().contains(searchQuery.value.toLowerCase())))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadChatHistory();
  }

  void setActiveTab(String tab) {
    activeTab.value = tab;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> loadChatHistory() async {
    isLoading.value = true;
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mock data - replace with actual API call
      _allChatSessions.value = [
        ChatSession(
          id: '1',
          title: 'Stomach hurts for 3 day straight',
          lastMessage: 'Thank you for the advice. I will try the suggested remedies.',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
          doctorAvatarUrl: 'https://via.placeholder.com/50',
          messages: List.generate(478, (index) => 'Message $index'),
          isTrashed: false,
        ),
        ChatSession(
          id: '2', 
          title: 'Blurry eyesight after eating meals',
          lastMessage: 'Should I be concerned about this recurring issue?',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
          doctorAvatarUrl: 'https://via.placeholder.com/50',
          messages: List.generate(15, (index) => 'Message $index'),
          isTrashed: false,
        ),
        ChatSession(
          id: '3',
          title: 'Knee suddenly hurts after jogging',
          lastMessage: 'The pain seems to be getting worse. What should I do?',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
          doctorAvatarUrl: 'https://via.placeholder.com/50', 
          messages: List.generate(28, (index) => 'Message $index'),
          isTrashed: false,
        ),
        ChatSession(
          id: '4',
          title: 'How to manage diabetes better',
          lastMessage: 'Thank you for the detailed meal plan suggestions.',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
          doctorAvatarUrl: 'https://via.placeholder.com/50',
          messages: List.generate(123, (index) => 'Message $index'),
          isTrashed: false,
        ),
      ];

      // Mock trashed sessions
      _trashedSessions.value = [
        ChatSession(
          id: '5',
          title: 'Old headache consultation',
          lastMessage: 'This session was moved to trash.',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 7)),
          doctorAvatarUrl: 'https://via.placeholder.com/50',
          messages: List.generate(45, (index) => 'Message $index'),
          isTrashed: true,
        ),
      ];
      
    } catch (e) {
      // Handle error
      print('Error loading chat history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshChatHistory() async {
    await loadChatHistory();
  }

  void openChatSession(ChatSession session) {
    // Navigate to chat detail page
  }

  void deleteChatSession(String sessionId) {
    // Move to trash instead of permanently deleting
    moveChatSessionToTrash(sessionId);
  }

  void moveChatSessionToTrash(String sessionId) {
    final sessionIndex = _allChatSessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      final session = _allChatSessions[sessionIndex];
      session.isTrashed = true;
      _trashedSessions.add(session);
      _allChatSessions.refresh(); // Trigger UI update
      _trashedSessions.refresh();
      
      Get.snackbar(
        'Moved to Trash',
        '${session.title} has been moved to trash',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void restoreChatSession(String sessionId) {
    final sessionIndex = _trashedSessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      final session = _trashedSessions[sessionIndex];
      session.isTrashed = false;
      _trashedSessions.removeAt(sessionIndex);
      _allChatSessions.refresh(); // Trigger UI update
      _trashedSessions.refresh();
      
      Get.snackbar(
        'Restored',
        '${session.title} has been restored',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void deleteChatSessionPermanently(String sessionId) {
    final sessionIndex = _trashedSessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex != -1) {
      final session = _trashedSessions.removeAt(sessionIndex);
      _trashedSessions.refresh();
      
      Get.snackbar(
        'Deleted Forever',
        '${session.title} has been permanently deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

