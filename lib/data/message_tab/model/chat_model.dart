class ChatListModel {
  final bool? success;
  final String? message;
  final ChatData? data;

  ChatListModel({
    this.success,
    this.message,
    this.data,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ChatData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ChatData {
  final List<ConversationModel>? conversations;
  final int? total;

  ChatData({
    this.conversations,
    this.total,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    conversations: json["conversations"] == null ? [] : List<ConversationModel>.from(json["conversations"]!.map((x) => ConversationModel.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "conversations": conversations == null ? [] : List<dynamic>.from(conversations!.map((x) => x.toJson())),
    "total": total,
  };
}

class ConversationModel {
  final String? conversationId;
  final String? status;
  final bool? isInitiator;
  final Recipient? recipient;
  final LastMessage? lastMessage;
  final int? unreadCount;
  final String? updatedAt;

  ConversationModel({
    this.conversationId,
    this.status,
    this.isInitiator,
    this.recipient,
    this.lastMessage,
    this.unreadCount,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
    conversationId: json["conversation_id"],
    status: json["status"],
    isInitiator: json["is_initiator"],
    recipient: json["recipient"] == null ? null : Recipient.fromJson(json["recipient"]),
    lastMessage: json["last_message"] == null ? null : LastMessage.fromJson(json["last_message"]),
    unreadCount: json["unread_count"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "conversation_id": conversationId,
    "status": status,
    "is_initiator": isInitiator,
    "recipient": recipient?.toJson(),
    "last_message": lastMessage?.toJson(),
    "unread_count": unreadCount,
    "updated_at": updatedAt,
  };
}

class LastMessage {
  final String? content;
  final String? messageType;
  final String? createdAt;
  final bool? isMine;

  LastMessage({
    this.content,
    this.messageType,
    this.createdAt,
    this.isMine,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    content: json["content"],
    messageType: json["message_type"],
    createdAt: json["created_at"] ,
    isMine: json["is_mine"],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    "message_type": messageType,
    "created_at": createdAt,
    "is_mine": isMine,
  };
}

class Recipient {
  final String? id;
  final String? fullName;
  final String? photoUrl;
  final bool? isVerified;
  final bool? isOnline;
  final String? lastSeen;

  Recipient({
    this.id,
    this.fullName,
    this.photoUrl,
    this.isVerified,
    this.isOnline,
    this.lastSeen,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
    id: json["id"],
    fullName: json["full_name"],
    photoUrl: json["photo_url"],
    isVerified: json["is_verified"],
    isOnline: json["is_online"],
    lastSeen: json["last_seen"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "photo_url": photoUrl,
    "is_verified": isVerified,
    "is_online": isOnline,
    "last_seen": lastSeen,
  };
}




/*class ChatModel {
  final String conversationId;
  final String name;
  final String image;
  final String lastMessage;
  final int unreadCount;
  final bool isOnline;
  final String status; // 'accepted', 'pending', 'declined'
  final bool isInitiator;

  ChatModel({
    required this.conversationId,
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.unreadCount,
    required this.isOnline,
    required this.status,
    required this.isInitiator,
  });
}*/