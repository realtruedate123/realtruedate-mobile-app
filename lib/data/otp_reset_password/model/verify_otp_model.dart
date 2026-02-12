class VerifyOtpModel {
  final bool? success;
  final String? message;
  final TokenData? data;

  VerifyOtpModel({
    this.success,
    this.message,
    this.data,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TokenData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TokenData {
  final Tokens? tokens;
  final String? email;
  final String? resetToken;

  TokenData({
    this.tokens,
    this.email = '' ,
    this.resetToken = '',
  });

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
    tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
    email: json["email"]?.toString() ?? "",
    resetToken: json["reset_token"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "tokens": tokens?.toJson(),
    "email": email,
    "reset_token": resetToken,
  };
}

class Tokens {
  final String? refresh;
  final String? access;

  Tokens({
    this.refresh,
    this.access,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    refresh: json["refresh"],
    access: json["access"],
  );

  Map<String, dynamic> toJson() => {
    "refresh": refresh,
    "access": access,
  };
}