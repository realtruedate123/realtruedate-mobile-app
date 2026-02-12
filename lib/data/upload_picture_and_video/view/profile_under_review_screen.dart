import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:get/get.dart';

class ProfileUnderReviewScreen extends StatelessWidget {
  const ProfileUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.lightPurpleColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.lightPurpleColor, // pink background
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Stack(
              children: [
                // Center content
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextFont(
                          'Profile Under Review',
                          font: AppFontType.manrope,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: theme.whiteColor,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.h),
                        AppTextFont(
                          'Thank you for your submission. We are reviewing your '
                              'profile to ensure it meets our standards. We’ll notify '
                              'you once it’s approved and active',
                          font: AppFontType.manrope,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: theme.whiteColor,
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          lineHeight: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // Logout button (bottom-right)
                Positioned(
                  right: 20.w,
                  bottom: 20.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(
                        Routes.authPage,
                        arguments: AuthTab.login,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextFont(
                          'Logout',
                          font: AppFontType.urbanist,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.whiteColor,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10.w),
                        AppIcons.getLogOutIcon(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
