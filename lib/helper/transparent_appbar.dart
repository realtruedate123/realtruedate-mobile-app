import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

class TransparentBackAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final double height;
  final Widget? leadingIcon;

  const TransparentBackAppBar({
    super.key,
    this.onBack,
    this.height = 50,
    this.leadingIcon,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: height,
      leading: IconButton(
        icon: leadingIcon ??
            AppIcons.getBackOutLineIcon(context, size: 30),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
    );
  }
}
