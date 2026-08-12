import 'package:flutter/cupertino.dart';

class ProfileMenuItem {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class ProfileSection {
  final String? title; // null = no section header
  final List<ProfileMenuItem> items;

  ProfileSection({
    this.title,
    required this.items,
  });
}

/// Delete user model

class DeleteUserModel {
  final bool? success;
  final String? message;
  final DeletedData? data;

  DeleteUserModel({
    this.success,
    this.message,
    this.data,
  });

  factory DeleteUserModel.fromJson(Map<String, dynamic> json) => DeleteUserModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : DeletedData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DeletedData {
  final bool? deleted;

  DeletedData({
    this.deleted,
  });

  factory DeletedData.fromJson(Map<String, dynamic> json) => DeletedData(
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "deleted": deleted,
  };
}
