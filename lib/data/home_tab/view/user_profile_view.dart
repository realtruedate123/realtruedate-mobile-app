import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/home_tab/controller/user_profile_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/appbar_wrapper/user_profile_appbar_wrapper.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/custom_dialog/reject_match_dialog.dart';

class UserProfileDetailsScreen extends StatelessWidget {
  final controller = Get.find<UserProfileController>();

  UserProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true, // This is key to allow the body to go behind the app bar
      backgroundColor: Colors.black,
      appBar: UserProfileAppbarWrapper(
        isStarFilled: controller.isFavorite,
        onStarTap: controller.toggleFavorite,
      ),
      body: Stack(
        children: [
          /// Profile Image
          Positioned.fill(
            child: Image.asset(
              AppIcons.dummyProfileDetailsCard,
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ),
          ),

          /// Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// White Card
                Container(
                  padding: EdgeInsets.fromLTRB(24.w, 64.h, 24.w, 32.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            AppTextFont(
                              'Cylra Cantika, 21',
                              font: AppFontType.urbanist,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: theme.dark,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            AppTextFont(
                              'Peak, Germany',
                              font: AppFontType.lato,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: theme.inactiveTabColor,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.h),
                      AppTextFont(
                        'About',
                        font: AppFontType.urbanist,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.blackColor,
                      ),
                      SizedBox(height: 8.h),
                      AppTextFont(
                        'Lorem Ipsum, cursus eu justo et, commodo malesuada lacus. Donec at felis eleifend, commodo urna quis, aliquam lectus.',
                        font: AppFontType.lato,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: theme.inactiveTabColor,
                        maxLines: 4,
                      ),

                      SizedBox(height: 24.h),
                      AppTextFont(
                        'Interest',
                        font: AppFontType.urbanist,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.blackColor,
                      ),
                      SizedBox(height: 12.h),

                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          _interestChip(context, 'Nature', filled: true),
                          _interestChip(context, 'Travel'),
                          _interestChip(context, 'Writing'),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Floating Buttons (HALF OVER CARD)
                Positioned(
                  top: -32.r,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            // TODO: cancel action
                            print('Cancel tapped');
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => RejectMatchDialog(),
                            );
                          },
                          child: AppIcons.getCancelCardIcon(context, size: 60)
                      ),
                      SizedBox(width: 24.w),
                      GestureDetector(
                          onTap: () {
                            // TODO: liked action
                            print('Liked tapped');
                          },
                          child: AppIcons.getLikeCardIcon(context, size: 60)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interestChip(BuildContext context, String text, {bool filled = false}) {
    final theme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: filled ? theme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: theme.primaryColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: filled ? Colors.white : theme.blackColor,
        ),
      ),
    );
  }
}