// class MessageModel {
//   final String id;
//   final String senderId;
//   final String message;
//   final String? imageUrl;
//   final bool isMe;
//   final String type; // 'text' or 'image'
//
//   MessageModel({
//     required this.id,
//     required this.senderId,
//     required this.message,
//     this.imageUrl,
//     required this.isMe,
//     this.type = 'text',
//   });
//
//   factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
//     return MessageModel(
//       id: json['message_id'] ?? '',
//       senderId: json['sender_id'] ?? '',
//       message: json['content'] ?? '',
//       imageUrl: json['image_url'],
//       isMe: json['sender_id'] == currentUserId,
//       type: json['message_type'] ?? 'text',
//     );
//   }
// }

/// Message List
class MessageListModel {
  final bool? success;
  final String? message;
  final ConversationData? data;

  MessageListModel({
    this.success,
    this.message,
    this.data,
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ConversationData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ConversationData {
  final String? conversationId;
  final String? status;
  final bool? isInitiator;
  final RecipientMessage? recipient;
  final List<MessageObject>? messages;
  final int? page;
  final int? pageSize;
  final bool? hasMore;

  ConversationData({
    this.conversationId,
    this.status,
    this.isInitiator,
    this.recipient,
    this.messages,
    this.page,
    this.pageSize,
    this.hasMore,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) => ConversationData(
    conversationId: json["conversation_id"],
    status: json["status"],
    isInitiator: json["is_initiator"],
    recipient: json["recipient"] == null ? null : RecipientMessage.fromJson(json["recipient"]),
    messages: json["messages"] == null ? [] : List<MessageObject>.from(json["messages"]!.map((x) => MessageObject.fromJson(x))),
    page: json["page"],
    pageSize: json["page_size"],
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "conversation_id": conversationId,
    "status": status,
    "is_initiator": isInitiator,
    "recipient": recipient?.toJson(),
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
    "page": page,
    "page_size": pageSize,
    "has_more": hasMore,
  };
}

class RecipientMessage {
  final String? id;
  final String? fullName;
  final int? age;
  final String? photoUrl;
  final bool? isOnline;

  RecipientMessage({
    this.id,
    this.fullName,
    this.age,
    this.photoUrl,
    this.isOnline,
  });

  factory RecipientMessage.fromJson(Map<String, dynamic> json) => RecipientMessage(
    id: json["id"],
    fullName: json["full_name"],
    age: json["age"],
    photoUrl: json["photo_url"],
    isOnline: json["is_online"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "age": age,
    "photo_url": photoUrl,
    "is_online": isOnline,
  };
}

class MessageObject {
  final String? id;
  final String? senderId;
  final bool? isMine;
  final String? messageType;
  final String? content;
  final String? imageUrl;
  final bool? isRead;
  final String? createdAt;

  MessageObject({
    this.id,
    this.senderId,
    this.isMine,
    this.messageType,
    this.content,
    this.imageUrl,
    this.isRead,
    this.createdAt,
  });

  factory MessageObject.fromJson(Map<String, dynamic> json) => MessageObject(
    id: json["id"],
    senderId: json["sender_id"],
    isMine: json["is_mine"],
    messageType: json["message_type"],
    content: json["content"],
    imageUrl: json["image_url"],
    isRead: json["is_read"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "is_mine": isMine,
    "message_type": messageType,
    "content": content,
    "image_url": imageUrl,
    "is_read": isRead,
    "created_at": createdAt,
  };
}
