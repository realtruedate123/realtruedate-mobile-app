import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

class UserProfileAppbarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isStarFilled;
  final VoidCallback onStarTap;
  final VoidCallback? onBack;

  const UserProfileAppbarWrapper({
    super.key,
    required this.isStarFilled,
    required this.onStarTap,
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
        child: AppBarIconButton(
          icon: AppIcons.getBackOutLineIcon(context, size: 38),
          onTap: onBack ?? () => Get.back(),
        ),
      ),

      actions: [
        AppIcons.getTickOutlineIcon(context, size: 38),
        SizedBox(width: 12.w),
        Obx(() => AppBarIconButton(
          icon: isStarFilled.value
              ? AppIcons.getStartFillOutlineIcon(context, size: 38)
              : AppIcons.getStartUnfillOutlineIcon(context, size: 38),
          onTap: onStarTap,
        )),
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
        // borderRadius: BorderRadius.circular(14.r),
        child: icon,
      ),
    );
  }
}
