class ProfileMatchDetailsModel {
  final bool? success;
  final String? message;
  final ProfileData? data;

  ProfileMatchDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProfileMatchDetailsModel.fromJson(Map<String, dynamic> json) => ProfileMatchDetailsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileData {
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? gender;
  final String? city;
  final String? state;
  final String? country;
  final String? bio;
  final String? occupation;
  final bool? isVerified;
  final bool? videoVerified;
  final bool? isOnline;
  final String? lastSeen;
  final List<Photo>? photos;
  final Profile? profile;
  final bool? isFavorite;

  ProfileData({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.city,
    this.state,
    this.country,
    this.bio,
    this.occupation,
    this.isVerified,
    this.videoVerified,
    this.isOnline,
    this.lastSeen,
    this.photos,
    this.profile,
    this.isFavorite,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    age: json["age"],
    gender: json["gender"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    bio: json["bio"],
    occupation: json["occupation"],
    isVerified: json["is_verified"],
    videoVerified: json["video_verified"],
    isOnline: json["is_online"],
    lastSeen: json["last_seen"],
    photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    isFavorite: json["is_favorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "age": age,
    "gender": gender,
    "city": city,
    "state": state,
    "country": country,
    "bio": bio,
    "occupation": occupation,
    "is_verified": isVerified,
    "video_verified": videoVerified,
    "is_online": isOnline,
    "last_seen": lastSeen,
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
    "profile": profile?.toJson(),
    "is_favorite": isFavorite,
  };
}

class Photo {
  final String? id;
  final String? photoUrl;
  final bool? isPrimary;
  final String? photoType;

  Photo({
    this.id,
    this.photoUrl,
    this.isPrimary,
    this.photoType,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["id"],
    photoUrl: json["photo_url"],
    isPrimary: json["is_primary"],
    photoType: json["photo_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo_url": photoUrl,
    "is_primary": isPrimary,
    "photo_type": photoType,
  };
}

class Profile {
  // final int? height;
  final String? bodyType;
  final String? ethnicity;
  final String? education;
  final String? religion;
  final String? smoking;
  final String? drinking;
  final List<String>? interests;
  final String? lookingFor;

  Profile({
    // this.height,
    this.bodyType,
    this.ethnicity,
    this.education,
    this.religion,
    this.smoking,
    this.drinking,
    this.interests,
    this.lookingFor,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    // height: json["height"],
    bodyType: json["body_type"],
    ethnicity: json["ethnicity"],
    education: json["education"],
    religion: json["religion"],
    smoking: json["smoking"],
    drinking: json["drinking"],
    interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
    lookingFor: json["looking_for"],
  );

  Map<String, dynamic> toJson() => {
    // "height": height,
    "body_type": bodyType,
    "ethnicity": ethnicity,
    "education": education,
    "religion": religion,
    "smoking": smoking,
    "drinking": drinking,
    "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
    "looking_for": lookingFor,
  };
}

/// Profile favorites
class ProfileFavoritesModel {
  final bool? success;
  final String? message;
  final ProfileFavoritesModelData? data;

  ProfileFavoritesModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProfileFavoritesModel.fromJson(Map<String, dynamic> json) => ProfileFavoritesModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileFavoritesModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileFavoritesModelData {
  final bool? isFavorite;

  ProfileFavoritesModelData({
    this.isFavorite,
  });

  factory ProfileFavoritesModelData.fromJson(Map<String, dynamic> json) => ProfileFavoritesModelData(
    isFavorite: json["is_favorite"],
  );

  Map<String, dynamic> toJson() => {
    "is_favorite": isFavorite,
  };
}