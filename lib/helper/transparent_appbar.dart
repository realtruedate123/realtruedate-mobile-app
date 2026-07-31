import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

class TransparentBackAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final double height;
  final Widget? leadingIcon;
  final bool backHide;
  final String? title; // optional title
  final TextStyle? titleStyle; // optional custom text style

  const TransparentBackAppBar({
    super.key,
    this.onBack,
    this.height = 50,
    this.leadingIcon,
    this.backHide = false,
    this.title,
    this.titleStyle,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true, // center the title
      title: title != null
          ? Text(
        title!,
        style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
      )
          : null,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      leading: backHide
          ? null
          : IconButton(
        icon: leadingIcon ??
            AppIcons.getBackOutLineIcon(context, size: 30),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
    );
  }
}