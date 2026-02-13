import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class MatchAppbarWrapper extends StatelessWidget
    implements PreferredSizeWidget {

  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFavoriteTap;
  final String title;

  const MatchAppbarWrapper({
    super.key,
    this.onBack,
    this.onNotificationTap,
    this.onFavoriteTap,
    this.title = "Matches",
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: AppTextFont(
        title,
        font: AppFontType.urbanist,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: theme.blackColor,
      ),
      // leading: Padding(
      //   padding: EdgeInsets.only(left: 16.w),
      //   child: _roundedIconButton(
      //     icon: AppIcons.getBackButtonIcon(context, size: 38),
      //     onTap: onBack ?? () => Navigator.pop(context),
      //   ),
      // ),
      actions: [
        _roundedIconButton(
          icon: AppIcons.getNotificationIcon(context, size: 38),
          onTap: onNotificationTap ?? () {},
        ),
        SizedBox(width: 12.w),
        _roundedIconButton(
          icon: AppIcons.getFavouriteIcon(context, size: 38),
          onTap: onFavoriteTap ?? () {},
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _roundedIconButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      splashColor: Colors.transparent, // Hides the ripple
      highlightColor: Colors.transparent, // Hides the click highlight
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: icon,
    );
  }
}