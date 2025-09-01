enum MessageType { user, ai, system }

enum MessageStatus { sending, sent, received, error }

class ConversationMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final String? errorMessage;

  ConversationMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.errorMessage,
  });

  factory ConversationMessage.user({
    required String content,
    String? id,
    MessageStatus status = MessageStatus.sent,
  }) {
    return ConversationMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
      status: status,
    );
  }

  factory ConversationMessage.ai({
    required String content,
    String? id,
    MessageStatus status = MessageStatus.sent,
  }) {
    return ConversationMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.ai,
      timestamp: DateTime.now(),
      status: status,
    );
  }

  factory ConversationMessage.system({
    required String content,
    String? id,
    MessageStatus status = MessageStatus.sent,
  }) {
    return ConversationMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.system,
      timestamp: DateTime.now(),
      status: status,
    );
  }

  ConversationMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    String? errorMessage,
  }) {
    return ConversationMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'errorMessage': errorMessage,
    };
  }

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      id: json['id'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.user,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      errorMessage: json['errorMessage'],
    );
  }

  @override
  String toString() {
    return 'ConversationMessage(id: $id, content: $content, type: $type, timestamp: $timestamp, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConversationMessage &&
        other.id == id &&
        other.content == content &&
        other.type == type &&
        other.timestamp == timestamp &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        type.hashCode ^
        timestamp.hashCode ^
        status.hashCode;
  }
}
