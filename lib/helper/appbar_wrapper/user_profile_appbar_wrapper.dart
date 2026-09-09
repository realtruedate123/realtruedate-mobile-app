import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

class UserProfileAppbarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isStarFilled;
  final VoidCallback onStarTap;
  final bool showShadow;
  final VoidCallback? onBack;

  const UserProfileAppbarWrapper({
    super.key,
    required this.isStarFilled,
    required this.onStarTap,
    this.showShadow = false,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 60.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: showShadow
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ]
                : [],
          ),
          child: AppBarIconButton(
            icon: AppIcons.getBackOutLineIcon(context, size: 38),
            onTap: onBack ?? () => Get.back(),
          ),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: showShadow
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ]
                : [],
          ),
          child: AppIcons.getTickOutlineIcon(context, size: 38),
        ),
        SizedBox(width: 12.w),
        Obx(
              () => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: showShadow
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ]
                  : [],
            ),
            child: AppBarIconButton(
              icon: isStarFilled.value
                  ? AppIcons.getStartFillOutlineIcon(context, size: 38)
                  : AppIcons.getStartUnfillOutlineIcon(context, size: 38),
              onTap: onStarTap,
            ),
          ),
        ),
        SizedBox(width: 12.w),
      ],
    );
  }
}


class AppBarIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final Color iconColor;

  const AppBarIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        splashColor: Colors.transparent, // Hides the ripple
        highlightColor: Colors.transparent, // Hides the click highlight
        onTap: onTap,
        child: icon,
      ),
    );
  }
}
