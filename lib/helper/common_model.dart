class CommonModel {
  final String? message;
  final bool? success;
  bool? tokenExpired;

  CommonModel({
    this.message,
    this.success,
    this.tokenExpired = false,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      message: json["message"],
      success: json["success"],
      tokenExpired: json["token_expired"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": success,
    "token_expired": tokenExpired,
  };
}