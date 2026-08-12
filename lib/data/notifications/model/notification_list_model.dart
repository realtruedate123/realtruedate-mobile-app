class NotificationListModel {
  final bool? success;
  final String? message;
  final DataModels? data;

  NotificationListModel({
    this.success,
    this.message,
    this.data,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : DataModels.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataModels {
  final List<NotificationObject>? notifications;
  final int? unreadCount;
  final int? page;
  final bool? hasMore;

  DataModels({
    this.notifications,
    this.unreadCount,
    this.page,
    this.hasMore,
  });

  factory DataModels.fromJson(Map<String, dynamic> json) => DataModels(
    notifications: json["notifications"] == null ? [] : List<NotificationObject>.from(json["notifications"]!.map((x) => NotificationObject.fromJson(x))),
    unreadCount: json["unread_count"],
    page: json["page"],
    hasMore: json["has_more"],
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "unread_count": unreadCount,
    "page": page,
    "has_more": hasMore,
  };
}

class NotificationObject {
  final String? id;
  final String? notificationType;
  final String? title;
  final String? body;
  final String? senderName;
  final String? senderPhoto;
  final String? conversationId;
  final String? conversationStatus;
  final bool? isRead;
  final String? createdAt;
  final String? senderId;

  NotificationObject({
    this.id,
    this.notificationType,
    this.title,
    this.body,
    this.senderName,
    this.senderPhoto,
    this.conversationId,
    this.conversationStatus,
    this.isRead,
    this.createdAt,
    this.senderId,
  });

  factory NotificationObject.fromJson(Map<String, dynamic> json) => NotificationObject(
    id: json["id"],
    notificationType: json["notification_type"],
    title: json["title"],
    body: json["body"],
    senderName: json["sender_name"],
    senderPhoto: json["sender_photo"],
    conversationId: json["conversation_id"],
    conversationStatus: json["conversation_status"],
    isRead: json["is_read"],
    createdAt: json["created_at"],
    senderId: json["sender_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "notification_type": notificationType,
    "title": title,
    "body": body,
    "sender_name": senderName,
    "sender_photo": senderPhoto,
    "conversation_id": conversationId,
    "conversation_status": conversationStatus,
    "is_read": isRead,
    "created_at": createdAt,
    "sender_id": senderId,
  };
}