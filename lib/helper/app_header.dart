import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool centerTitle;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? elevation;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.centerTitle = false,
    this.onBack,
    this.backgroundColor,
    this.iconColor,
    this.elevation,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBar(
      backgroundColor: backgroundColor ?? theme.buttonText,
      scrolledUnderElevation: elevation ?? 0,
      leading: showBack
          ? IconButton(
        icon: AppIcons.getBackButtonIcon(context, size: 38),
        onPressed: onBack ??
                () {
              if (Get.previousRoute.isNotEmpty) {
                Get.back();
              } else {
                // fallback navigation
                Navigator.of(context).maybePop();
              }
            },
      )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: theme.headingText,
          fontSize: MediaQuery.textScalerOf(context).scale(20.0),
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
