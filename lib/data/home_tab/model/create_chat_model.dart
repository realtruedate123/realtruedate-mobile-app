class CreateChatModel {
  final bool? success;
  final String? message;
  final ConversationDataModel? data;

  CreateChatModel({
    this.success,
    this.message,
    this.data,
  });

  factory CreateChatModel.fromJson(Map<String, dynamic> json) => CreateChatModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ConversationDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ConversationDataModel {
  final String? conversationId;
  final String? status;
  final bool? isInitiator;
  final RecipientModel? recipient;

  ConversationDataModel({
    this.conversationId,
    this.status,
    this.isInitiator,
    this.recipient,
  });

  factory ConversationDataModel.fromJson(Map<String, dynamic> json) => ConversationDataModel(
    conversationId: json["conversation_id"],
    status: json["status"],
    isInitiator: json["is_initiator"],
    recipient: json["recipient"] == null ? null : RecipientModel.fromJson(json["recipient"]),
  );

  Map<String, dynamic> toJson() => {
    "conversation_id": conversationId,
    "status": status,
    "is_initiator": isInitiator,
    "recipient": recipient?.toJson(),
  };
}

class RecipientModel {
  final String? id;
  final String? fullName;
  final String? photoUrl;

  RecipientModel({
    this.id,
    this.fullName,
    this.photoUrl,
  });

  factory RecipientModel.fromJson(Map<String, dynamic> json) => RecipientModel(
    id: json["id"],
    fullName: json["full_name"],
    photoUrl: json["photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "photo_url": photoUrl,
  };
}