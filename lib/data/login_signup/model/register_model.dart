class RegisterResponseModel {
  String? message;
  bool? success;
  RegisterResponse? data;

  RegisterResponseModel({
    this.message,
    this.success,
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];

    // Handle when "data" is an empty object {} or null
    final parsedData = (rawData is Map && rawData.isEmpty)
        ? null
        : rawData;

    return RegisterResponseModel(
      message: json["message"],
      success: json["success"],
      data: RegisterResponse.fromJson(parsedData),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "data": data ?? {},
  };
}

class RegisterResponse {
  String? email;
  bool? otpSent;
  int? otp;
  Tokens? tokens;
  VerificationStatus? verificationStatus;

  RegisterResponse({
    this.email = "",
    this.otpSent = false,
    this.otp = 0,
    this.tokens,
    this.verificationStatus,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      email: json["email"]?.toString() ?? "",
      otpSent: json["otp_sent"] ?? false,
      otp: json["otp"] ?? 0,
      tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
      verificationStatus: json["verification_status"] == null ? null : VerificationStatus.fromJson(json["verification_status"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp_sent": otpSent,
      "otp": otp,
      "tokens": tokens?.toJson(),
      "verification_status": verificationStatus?.toJson(),
    };
  }
}

class Tokens {
  final String? refresh;
  final String? access;

  Tokens({
    this.refresh,
    this.access,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    refresh: json["refresh"] as String,
    access: json["access"] as String,
  );

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
  };
}

class VerificationStatus {
  final bool? photoVerified;
  final bool? videoVerified;
  final bool? isVerified;
  final bool? hasDreamDateProfile;

  VerificationStatus({
    this.photoVerified,
    this.videoVerified,
    this.isVerified = false,
    this.hasDreamDateProfile,
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) => VerificationStatus(
    photoVerified: json["photo_verified"] as bool,
    videoVerified: json["video_verified"] as bool,
    isVerified: json["is_verified"] as bool,
    hasDreamDateProfile: json["has_dream_date_profile"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "photo_verified": photoVerified,
    "video_verified": videoVerified,
    "is_verified": isVerified,
    "has_dream_date_profile": hasDreamDateProfile,
  };
}

/// Refresh token model
class RefreshTokenModel {
  final bool? success;
  final String? message;
  final RefreshTokenData? data;
  final bool? tokenExpired;

  RefreshTokenModel({
    this.success,
    this.message,
    this.data,
    this.tokenExpired,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : RefreshTokenData.fromJson(json["data"]),
    tokenExpired: json["token_expired"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "token_expired": tokenExpired,
  };
}

class RefreshTokenData {
  final String? access;
  final String? refresh;

  RefreshTokenData({
    this.access,
    this.refresh,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) => RefreshTokenData(
    access: json["access"],
    refresh: json["refresh"],
  );

  Map<String, dynamic> toJson() => {
    "access": access,
    "refresh": refresh,
  };
}