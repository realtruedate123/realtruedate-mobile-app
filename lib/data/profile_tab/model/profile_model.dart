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
