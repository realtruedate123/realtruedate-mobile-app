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

//TODO: Get Address base on user location
class UserLocationAddressModel {
  final String? streetName;
  final String? areName;
  final String? cityName;
  final String? stateName;
  final String? postalCode;
  final String? country;
  final double? latitude;
  final double? longitude;

  UserLocationAddressModel({
    this.streetName,
    this.areName,
    this.cityName,
    this.stateName,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
  });

  factory UserLocationAddressModel.fromJson(Map<String, dynamic> json) => UserLocationAddressModel(
    streetName: json['street'] as String?,
    areName: json['subLocality'] as String?,
    cityName: json['locality'] as String?,
    stateName: json['administrativeArea'] as String?,
    postalCode: json['postalCode'] as String?,
    country: json['country'] as String?,
    latitude:
    json['latitude'] != null ? (json['latitude'] as num).toDouble() : 0.0,
    longitude:
    json['longitude'] != null ? (json['longitude'] as num).toDouble() : 0.0,
  );

  Map<String, dynamic> toJson() => {
    'street': streetName,
    'subLocality': areName,
    'locality': cityName,
    'administrativeArea': stateName,
    'postalCode': postalCode,
    'country': country,
    'latitude': latitude,
    'longitude': longitude,
  };
}