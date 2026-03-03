import 'package:flutter/cupertino.dart';

class SavedProfileModel {
  final String name;
  final int age;
  final String location;
  final String imageUrl;
  final int matchPercent;
  final bool isVerified;
   bool like;

  SavedProfileModel({
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
    required this.matchPercent,
    this.isVerified = false,
    this.like = false,
  });
}