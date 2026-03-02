class SwipeCardModel {
  final bool success;
  final String message;
  final SwipeData data;

  SwipeCardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SwipeCardModel.fromJson(Map<String, dynamic> json) => SwipeCardModel(
    success: json["success"],
    message: json["message"],
    data: SwipeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class SwipeData {
  final bool matched;
  // final String matchId;

  SwipeData({
    required this.matched,
    // required this.matchId,
  });

  factory SwipeData.fromJson(Map<String, dynamic> json) => SwipeData(
    matched: json["matched"],
    // matchId: json["match_id"],
  );

  Map<String, dynamic> toJson() => {
    "matched": matched,
    // "match_id": matchId,
  };
}