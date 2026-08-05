
class SavedProfileModel {
  final bool? success;
  final String? message;
  final SavedProfileData? data;

  SavedProfileModel({
    this.success,
    this.message,
    this.data,
  });

  factory SavedProfileModel.fromJson(Map<String, dynamic> json) => SavedProfileModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : SavedProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class SavedProfileData {
  final List<FavoriteModel>? favorites;
  final int? total;

  SavedProfileData({
    this.favorites,
    this.total,
  });

  factory SavedProfileData.fromJson(Map<String, dynamic> json) => SavedProfileData(
    favorites: json["favorites"] == null ? [] : List<FavoriteModel>.from(json["favorites"]!.map((x) => FavoriteModel.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "favorites": favorites == null ? [] : List<dynamic>.from(favorites!.map((x) => x.toJson())),
    "total": total,
  };
}

class FavoriteModel {
  final String? userId;
  final String? fullName;
  final int? age;
  final String? photoUrl;
  final bool? isVerified;

  FavoriteModel({
    this.userId,
    this.fullName,
    this.age,
    this.photoUrl,
    this.isVerified,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    userId: json["user_id"],
    fullName: json["full_name"],
    age: json["age"],
    photoUrl: json["photo_url"],
    isVerified: json["is_verified"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "full_name": fullName,
    "age": age,
    "photo_url": photoUrl,
    "is_verified": isVerified,
  };
}