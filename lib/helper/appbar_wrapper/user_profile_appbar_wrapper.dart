import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/custom_dialog/confirmation_dialog.dart';

class UserProfileAppbarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isStarFilled;
  final VoidCallback onStarTap;
  final bool showShadow;
  final bool isBlocked;
  final bool isBlockedButton;
  final VoidCallback? onBack;
  final VoidCallback? onBlock;

  const UserProfileAppbarWrapper({
    super.key,
    required this.isStarFilled,
    required this.onStarTap,
    this.showShadow = false,
    this.isBlocked = false,
    this.isBlockedButton = false,
    this.onBack,
    this.onBlock,
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
        if(isBlockedButton)...[
          SizedBox(width: 5.w),
          AppBarIconButton(
            icon: AppIcons.getCloseWhite(context, size: 38),
            onTap: () => _showBlockPopup(context),
          ),
        ],
        SizedBox(width: 10.w),
      ],
    );
  }

  void _showBlockPopup(BuildContext context) {
    // if (onBlock != null) {
    //   onBlock!();
    //   print('return onBlock');
    //   return;
    // }
    final blockUserText = isBlocked ? 'Unblock' : 'Block';

    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        final theme = AppTheme.of(context);
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: 60.h, // adjust based on your AppBar height
                right: 16.w,
                child: InkWell(
                  splashColor: Colors.transparent, // Hides the ripple
                  highlightColor: Colors.transparent, // Hides the click highlight
                  onTap: () {
                    // Entire view click action
                    Get.back();
                    showDialog(
                      context: context,
                      barrierColor: Colors.black12.withAlpha(204),
                      builder: (context) => ConfirmationDialog(
                        title: '$blockUserText User',
                        message: 'Are you sure you want to ${blockUserText.toLowerCase()}. this user?',
                        onConfirm: () {
                          Get.back();
                          onBlock?.call();
                        },
                        confirmText: blockUserText,
                        cancelText: 'Cancel',
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.r), // white border thickness
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: AppTextFont(
                        isBlocked ? 'Unblock' : 'Block',
                        font: AppFontType.inter,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
