// Model for Subscription Data
class SubscriptionPlan {
  final String title;
  final String price;
  final String featureText;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.featureText,
  });
}

/// Subscriptions save model
class SubscriptionSaveModel {
  final bool? success;
  final String? message;
  final SubscriptionSaveData? data;

  SubscriptionSaveModel({
    this.success,
    this.message,
    this.data,
  });

  factory SubscriptionSaveModel.fromJson(Map<String, dynamic> json) => SubscriptionSaveModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : SubscriptionSaveData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class SubscriptionSaveData {
  final bool? isPremium;
  final String? expiresAt;

  SubscriptionSaveData({
    this.isPremium,
    this.expiresAt,
  });

  factory SubscriptionSaveData.fromJson(Map<String, dynamic> json) => SubscriptionSaveData(
    isPremium: json["is_premium"],
    expiresAt: json["expires_at"],
  );

  Map<String, dynamic> toJson() => {
    "is_premium": isPremium,
    "expires_at": expiresAt,
  };
}

/// Subscription Status Model
class SubscriptionStatusModel {
  final bool? success;
  final String? message;
  final SubscriptionStatusData? data;

  SubscriptionStatusModel({
    this.success,
    this.message,
    this.data,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) => SubscriptionStatusModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : SubscriptionStatusData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class SubscriptionStatusData {
  final bool? isPremium;
  final String? premiumExpiresAt;
  final int? freeSwipesUsed;
  final int? freeSwipesLimit;
  final String? freeSwipesResetAt;
  final bool? isExpired;

  SubscriptionStatusData({
    this.isPremium,
    this.premiumExpiresAt,
    this.freeSwipesUsed,
    this.freeSwipesLimit,
    this.freeSwipesResetAt,
    this.isExpired,
  });

  factory SubscriptionStatusData.fromJson(Map<String, dynamic> json) => SubscriptionStatusData(
    isPremium: json["is_premium"],
    premiumExpiresAt: json["premium_expires_at"],
    freeSwipesUsed: json["free_swipes_used"],
    freeSwipesLimit: json["free_swipes_limit"],
    freeSwipesResetAt: json["free_swipes_reset_at"],
    isExpired: json["is_expired"],
  );

  Map<String, dynamic> toJson() => {
    "is_premium": isPremium,
    "premium_expires_at": premiumExpiresAt,
    "free_swipes_used": freeSwipesUsed,
    "free_swipes_limit": freeSwipesLimit,
    "free_swipes_reset_at": freeSwipesResetAt,
    "is_expired": isExpired,
  };
}