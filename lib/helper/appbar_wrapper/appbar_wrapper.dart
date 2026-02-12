import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';

class AppbarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Make optional for hide/show
  final bool showBack; // Show/hide back button
  final bool centerTitle; // Align title center
  final TextAlign? titleAlign; // Optional fine-grained alignment
  final VoidCallback? onBack; // Back button callback
  final Color? backgroundColor; // AppBar background color
  final Color? iconColor; // Back button & action icons color
  final double? elevation; // AppBar elevation
  final List<Widget>? actions; // Right-side buttons

  const AppbarWrapper({
    super.key,
    this.title,
    this.showBack = true,
    this.centerTitle = false,
    this.titleAlign,
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
      elevation: elevation ?? 0,
      leading: showBack
          ? IconButton(
        icon: AppIcons.getBackOutLineIcon(context, size: 24),
        onPressed: onBack ??
                () {
              if (Get.previousRoute.isNotEmpty) {
                Get.back();
              } else {
                Navigator.of(context).maybePop();
              }
            },
      )
          : null,
      title: title != null
          ? Align(
        alignment: _getAlignment(),
        child: Text(
          title!,
          textAlign: titleAlign ?? TextAlign.left,
          style: TextStyle(
            color: theme.headingText,
            fontSize: MediaQuery.textScalerOf(context).scale(20.0),
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      )
          : null,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  /// Converts centerTitle / titleAlign to Alignment
  Alignment _getAlignment() {
    if (centerTitle) return Alignment.center;
    switch (titleAlign) {
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.left:
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
