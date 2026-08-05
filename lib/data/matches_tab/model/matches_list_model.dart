class MatchesListModel {
  final bool? success;
  final String? message;
  final MatchesData? data;

  MatchesListModel({
    this.success,
    this.message,
    this.data,
  });

  factory MatchesListModel.fromJson(Map<String, dynamic> json) => MatchesListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : MatchesData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MatchesData {
  final List<MatchList>? matches;
  final int? total;

  MatchesData({
    this.matches,
    this.total,
  });

  factory MatchesData.fromJson(Map<String, dynamic> json) => MatchesData(
    matches: json["matches"] == null ? [] : List<MatchList>.from(json["matches"]!.map((x) => MatchList.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "matches": matches == null ? [] : List<dynamic>.from(matches!.map((x) => x.toJson())),
    "total": total,
  };
}

class MatchList {
  final String? matchId;
  final String? matchedAt;
  final double? matchPercentage;
  final User? user;

  MatchList({
    this.matchId,
    this.matchedAt,
    this.matchPercentage,
    this.user,
  });

  factory MatchList.fromJson(Map<String, dynamic> json) => MatchList(
    matchId: json["match_id"],
    matchedAt: json["matched_at"],
    matchPercentage: json["match_percentage"]?.toDouble(),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "match_id": matchId,
    "matched_at": matchedAt,
    "match_percentage": matchPercentage,
    "user": user?.toJson(),
  };
}

class User {
  final String? id;
  final String? username;
  final String? firstName;
  final String? photoUrl;
  final bool? isVerified;
  final String? city;
  final String? state;
  final int? age;

  User({
    this.id,
    this.username,
    this.firstName,
    this.photoUrl,
    this.isVerified,
    this.city,
    this.state,
    this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    firstName: json["first_name"],
    photoUrl: json["photo_url"],
    isVerified: json["is_verified"],
    city: json["city"],
    state: json["state"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "photo_url": photoUrl,
    "is_verified": isVerified,
    "city": city,
    "state": state,
    "age": age,
  };
}