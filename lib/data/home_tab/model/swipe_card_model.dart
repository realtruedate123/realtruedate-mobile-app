class SwipeCardModel {
  final bool? success;
  final String? message;
  final SwipeData? data;

  SwipeCardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SwipeCardModel.fromJson(Map<String, dynamic> json) => SwipeCardModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : SwipeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class SwipeData {
  final bool? matched;
  final String? matchId;
  final bool? subscriptionRequired;

  SwipeData({
    this.matched,
    this.matchId,
    this.subscriptionRequired,
  });

  factory SwipeData.fromJson(Map<String, dynamic> json) => SwipeData(
    matched: json["matched"],
    matchId: json["match_id"] != null
        ? json["match_id"] as String
        : '',
    subscriptionRequired: json["subscription_required"],
  );

  Map<String, dynamic> toJson() => {
    "matched": matched,
    "match_id": matchId,
    "subscription_required": subscriptionRequired,
  };
}