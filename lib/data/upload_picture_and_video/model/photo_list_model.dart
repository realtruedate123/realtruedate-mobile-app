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