class PhotoListModel {
  final bool? success;
  final String? message;
  final PhotoList? data;
  final bool? tokenExpired;

  PhotoListModel({
    this.success,
    this.message,
    this.data,
    this.tokenExpired = false,
  });

  factory PhotoListModel.fromJson(Map<String, dynamic> json) => PhotoListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PhotoList.fromJson(json["data"]),
    tokenExpired: json["token_expired"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "token_expired": tokenExpired,
  };
}

class PhotoList {
  final List<PhotoObject>? photos;
  final int? count;

  PhotoList({
    this.photos,
    this.count,
  });

  factory PhotoList.fromJson(Map<String, dynamic> json) => PhotoList(
    photos: json["photos"] == null ? [] : List<PhotoObject>.from(json["photos"]!.map((x) => PhotoObject.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
    "count": count,
  };
}

class PhotoObject {
  final String? id;
  final String? photo;
  final String? photoUrl;

  PhotoObject({
    this.id,
    this.photo,
    this.photoUrl,
  });

  factory PhotoObject.fromJson(Map<String, dynamic> json) => PhotoObject(
    id: json["id"],
    photo: json["photo"],
    photoUrl: json["photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "photo_url": photoUrl,
  };
}

/// TODO: Challenges model
class ChallengesListModel {
  final bool? success;
  final String? message;
  final DataChallenges? data;

  ChallengesListModel({
    this.success,
    this.message,
    this.data,
  });

  factory ChallengesListModel.fromJson(Map<String, dynamic> json) => ChallengesListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : DataChallenges.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataChallenges {
  final String? sessionId;
  final String? expiresAt;
  final List<Challenge>? challenges;

  DataChallenges({
    this.sessionId,
    this.expiresAt,
    this.challenges,
  });

  factory DataChallenges.fromJson(Map<String, dynamic> json) => DataChallenges(
    sessionId: json["session_id"],
    expiresAt: json["expires_at"],
    challenges: json["challenges"] == null ? [] : List<Challenge>.from(json["challenges"]!.map((x) => Challenge.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "expires_at": expiresAt,
    "challenges": challenges == null ? [] : List<dynamic>.from(challenges!.map((x) => x.toJson())),
  };
}

class Challenge {
  final String? id;
  final String? type;
  final String? instruction;
  final int? order;

  Challenge({
    this.id,
    this.type,
    this.instruction,
    this.order,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json["id"],
    type: json["type"],
    instruction: json["instruction"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "instruction": instruction,
    "order": order,
  };
}