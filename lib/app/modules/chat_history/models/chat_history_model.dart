// Enhanced ChatSession model
class ChatSession {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String doctorAvatarUrl;
  final List<String> messages;
  bool isTrashed;

  ChatSession({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.doctorAvatarUrl,
    required this.messages,
    this.isTrashed = false,
  });

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'doctorAvatarUrl': doctorAvatarUrl,
      'messages': messages,
      'isTrashed': isTrashed,
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      doctorAvatarUrl: json['doctorAvatarUrl'],
      messages: List<String>.from(json['messages']),
      isTrashed: json['isTrashed'] ?? false,
    );
  }
}