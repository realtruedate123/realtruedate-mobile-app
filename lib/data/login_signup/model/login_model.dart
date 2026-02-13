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
  DateTime? createdAt;

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
    id: json["id"],
    photoUrl: json["photo_url"],
    photoType: json["photo_type"],
    isPrimary: json["is_primary"],
    isVerified: json["is_verified"],
    order: json["order"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo_url": photoUrl,
    "photo_type": photoType,
    "is_primary": isPrimary,
    "is_verified": isVerified,
    "order": order,
    "created_at": createdAt?.toIso8601String(),
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
    height: json["height"],
    weight: json["weight"],
    bodyType: json["body_type"],
    ethnicity: json["ethnicity"],
    education: json["education"],
    religion: json["religion"],
    smoking: json["smoking"],
    drinking: json["drinking"],
    lookingFor: json["looking_for"],
    minAgePreference: json["min_age_preference"],
    maxAgePreference: json["max_age_preference"],
    maxDistance: json["max_distance"],
    interests: json["interests"],
    profileVisible: json["profile_visible"],
    showDistance: json["show_distance"],
    showLastActive: json["show_last_active"],
    showAge: json["show_age"],
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
  DateTime? dateOfBirth;
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
  DateTime? createdAt;
  DateTime? lastLogin;

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
    id: json["id"],
    email: json["email"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    fullName: json["full_name"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    gender: json["gender"],
    bio: json["bio"],
    location: json["location"],
    zipCode: json["zip_code"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    occupation: json["occupation"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isPremium: json["is_premium"],
    tokens: json["tokens"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
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
    "created_at": createdAt?.toIso8601String(),
    "last_login": lastLogin?.toIso8601String(),
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
  DateTime? lastPhotoUpdate;

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
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) => VerificationStatus(
    photoVerified: json["photo_verified"],
    videoVerified: json["video_verified"],
    emailVerified: json["email_verified"],
    isVerified: json["is_verified"],
    verifiedPhotosCount: json["verified_photos_count"],
    totalPhotosCount: json["total_photos_count"],
    requiredPhotosCount: json["required_photos_count"],
    needsPhotoUpdate: json["needs_photo_update"],
    lastPhotoUpdate: json["last_photo_update"] == null ? null : DateTime.parse(json["last_photo_update"]),
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
    "last_photo_update": lastPhotoUpdate?.toIso8601String(),
  };
}