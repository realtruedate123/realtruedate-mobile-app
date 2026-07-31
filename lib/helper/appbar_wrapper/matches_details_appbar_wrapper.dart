import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/matches_tab/controller/matches_details_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/custom_dialog/user_block_dialog.dart';

class MatchesDetailsAppbarWrapper extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showCloseButton;
  final bool verifiedProfile;
  final bool showShadow;
  final VoidCallback? onBack;
  final VoidCallback? onBlock;
  final MatchesDetailsController controller; // add dynamic controller

  const MatchesDetailsAppbarWrapper({
    super.key,
    this.showCloseButton = false,
    this.verifiedProfile = false,
    this.showShadow = false,
    this.onBack,
    this.onBlock,
    required this.controller,
  });

  void _showBlockPopup(BuildContext context) {
    if (onBlock != null) {
      onBlock!();
      return;
    }

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
                    print('block click');
                    Get.back();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => UserBlockDialog(
                        onSure: () {
                          // Block user
                          controller.blockUserApiCall();
                        },
                        onCancel: () {
                          // Optional cancel action
                        },
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
                        'Block',
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

  Widget _iconContainer({
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 55.w,
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
          child: _iconContainer(
            icon: AppIcons.getBackOutLineIcon(context, size: 35),
            onTap: onBack ?? () => Get.back(),
          ),
        ),
      ),
      actions: [
        /// Verified Badge
        if(verifiedProfile)...[
          AppIcons.getTickOutlineIcon(context, size: 38),
        ],

        /// Close Button (flag based)
        if (showCloseButton)
          // Padding(
          //   padding: EdgeInsets.only(right: 16.w, left: 12.w),
          //   child: _iconContainer(
          //     icon: AppIcons.getCloseWhite(context, size: 38),
          //     onTap: () => _showBlockPopup(context),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(right: 16.w, left: 12.w),
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
              child: _iconContainer(
                icon: AppIcons.getCloseWhite(context, size: 38),
                onTap: () => _showBlockPopup(context),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
