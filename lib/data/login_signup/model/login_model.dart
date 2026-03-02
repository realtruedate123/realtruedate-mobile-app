class LoginModel {
  bool? success;
  String? message;
  DataModel? data;

  LoginModel({
    this.success,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : DataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataModel {
  TokensModel? tokens;
  UserModel? user;
  ProfileModel? profile;
  List<PhotoModel>? photos;
  VerificationStatus? verificationStatus;

  DataModel({
    this.tokens,
    this.user,
    this.profile,
    this.photos,
    this.verificationStatus,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    tokens: json["tokens"] == null ? null : TokensModel.fromJson(json["tokens"]),
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    profile: json["profile"] == null ? null : ProfileModel.fromJson(json["profile"]),
    photos: json["photos"] == null ? [] : List<PhotoModel>.from(json["photos"]!.map((x) => PhotoModel.fromJson(x))),
    verificationStatus: json["verification_status"] == null ? null : VerificationStatus.fromJson(json["verification_status"]),
  );

  Map<String, dynamic> toJson() => {
    "tokens": tokens?.toJson(),
    "user": user?.toJson(),
    "profile": profile?.toJson(),
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
    "verification_status": verificationStatus?.toJson(),
  };
}

class PhotoModel {
  String? id;
  String? photoUrl;
  String? photoType;
  bool? isPrimary;
  bool? isVerified;
  int? order;
  String? createdAt;

  PhotoModel({
    this.id,
    this.photoUrl,
    this.photoType,
    this.isPrimary,
    this.isVerified,
    this.order,
    this.createdAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
    id: json["id"] as String,
    photoUrl: json["photo_url"] as String,
    photoType: json["photo_type"] as String,
    isPrimary: json["is_primary"] as bool,
    isVerified: json["is_verified"] as bool,
    order: json["order"] as int,
    createdAt: json["created_at"] as String,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo_url": photoUrl,
    "photo_type": photoType,
    "is_primary": isPrimary,
    "is_verified": isVerified,
    "order": order,
    "created_at": createdAt,
  };
}

class ProfileModel {
  String? height;
  String? weight;
  String? bodyType;
  String? ethnicity;
  String? education;
  String? religion;
  String? smoking;
  String? drinking;
  String? lookingFor;
  int? minAgePreference;
  int? maxAgePreference;
  int? maxDistance;
  String? interests;
  bool? profileVisible;
  bool? showDistance;
  bool? showLastActive;
  bool? showAge;

  ProfileModel({
    this.height,
    this.weight,
    this.bodyType,
    this.ethnicity,
    this.education,
    this.religion,
    this.smoking,
    this.drinking,
    this.lookingFor,
    this.minAgePreference,
    this.maxAgePreference,
    this.maxDistance,
    this.interests,
    this.profileVisible,
    this.showDistance,
    this.showLastActive,
    this.showAge,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    height: json["height"] as String,
    weight: json["weight"] as String,
    bodyType: json["body_type"] as String,
    ethnicity: json["ethnicity"] as String,
    education: json["education"] as String,
    religion: json["religion"] as String,
    smoking: json["smoking"] as String,
    drinking: json["drinking"] as String,
    lookingFor: json["looking_for"] as String,
    minAgePreference: json["min_age_preference"] as int,
    maxAgePreference: json["max_age_preference"] as int,
    maxDistance: json["max_distance"] as int,
    interests: json["interests"] as String,
    profileVisible: json["profile_visible"] as bool,
    showDistance: json["show_distance"] as bool,
    showLastActive: json["show_last_active"] as bool,
    showAge: json["show_age"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "weight": weight,
    "body_type": bodyType,
    "ethnicity": ethnicity,
    "education": education,
    "religion": religion,
    "smoking": smoking,
    "drinking": drinking,
    "looking_for": lookingFor,
    "min_age_preference": minAgePreference,
    "max_age_preference": maxAgePreference,
    "max_distance": maxDistance,
    "interests": interests,
    "profile_visible": profileVisible,
    "show_distance": showDistance,
    "show_last_active": showLastActive,
    "show_age": showAge,
  };
}

class TokensModel {
  String? refresh;
  String? access;

  TokensModel({
    this.refresh,
    this.access,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) => TokensModel(
    refresh: json["refresh"],
    access: json["access"],
  );

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
  };
}

class UserModel {
  String? id;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? bio;
  String? location;
  String? zipCode;
  String? city;
  String? state;
  String? country;
  String? occupation;
  String? latitude;
  String? longitude;
  bool? isPremium;
  int? tokens;
  String? createdAt;
  String? lastLogin;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.location,
    this.zipCode,
    this.city,
    this.state,
    this.country,
    this.occupation,
    this.latitude,
    this.longitude,
    this.isPremium,
    this.tokens,
    this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] as String,
    email: json["email"] as String,
    username: json["username"] as String,
    firstName: json["first_name"] as String,
    lastName: json["last_name"] as String,
    fullName: json["full_name"] as String,
    dateOfBirth: json["date_of_birth"] as String,
    gender: json["gender"] as String,
    bio: json["bio"] as String,
    location: json["location"] as String,
    zipCode: json["zip_code"] as String,
    city: json["city"] as String,
    state: json["state"] as String,
    country: json["country"] as String,
    occupation: json["occupation"] as String,
    latitude: json["latitude"] as String,
    longitude: json["longitude"] as String,
    isPremium: json["is_premium"] as bool,
    tokens: json["tokens"] as int,
    createdAt: json["created_at"] as String,
    lastLogin: json["last_login"] as String,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "bio": bio,
    "location": location,
    "zip_code": zipCode,
    "city": city,
    "state": state,
    "country": country,
    "occupation": occupation,
    "latitude": latitude,
    "longitude": longitude,
    "is_premium": isPremium,
    "tokens": tokens,
    "created_at": createdAt,
    "last_login": lastLogin,
  };
}

class VerificationStatus {
  bool? photoVerified;
  bool? videoVerified;
  bool? emailVerified;
  bool? isVerified;
  int? verifiedPhotosCount;
  int? totalPhotosCount;
  int? requiredPhotosCount;
  bool? needsPhotoUpdate;
  String? lastPhotoUpdate;
  bool? hasDreamDateProfile;

  VerificationStatus({
    this.photoVerified,
    this.videoVerified,
    this.emailVerified,
    this.isVerified,
    this.verifiedPhotosCount,
    this.totalPhotosCount,
    this.requiredPhotosCount,
    this.needsPhotoUpdate,
    this.lastPhotoUpdate,
    this.hasDreamDateProfile,
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) => VerificationStatus(
    photoVerified: json["photo_verified"] as bool,
    videoVerified: json["video_verified"] as bool,
    emailVerified: json["email_verified"] as bool,
    isVerified: json["is_verified"] as bool,
    verifiedPhotosCount: json["verified_photos_count"] as int,
    totalPhotosCount: json["total_photos_count"] as int,
    requiredPhotosCount: json["required_photos_count"] as int,
    needsPhotoUpdate: json["needs_photo_update"] as bool,
    lastPhotoUpdate: json["last_photo_update"] as String,
    hasDreamDateProfile: json["has_dream_date_profile"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "photo_verified": photoVerified,
    "video_verified": videoVerified,
    "email_verified": emailVerified,
    "is_verified": isVerified,
    "verified_photos_count": verifiedPhotosCount,
    "total_photos_count": totalPhotosCount,
    "required_photos_count": requiredPhotosCount,
    "needs_photo_update": needsPhotoUpdate,
    "last_photo_update": lastPhotoUpdate,
    "has_dream_date_profile": hasDreamDateProfile,
  };
}