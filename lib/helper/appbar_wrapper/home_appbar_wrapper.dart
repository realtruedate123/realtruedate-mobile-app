import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/routes/routes.dart';

class HomeAppbarWrapper extends StatelessWidget {
  const HomeAppbarWrapper({super.key});

  static double height = 85.h;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h,),
                AppTextFont(
                  'Discover',
                  font: AppFontType.urbanist,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                ),
                SizedBox(height: 4.h),
                AppTextFont(
                  'Meet RealTrueDate – 100% Real People &\nPictures',
                  font: AppFontType.lato,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.inactiveTabColor,
                  maxLines: 2,
                ),
              ],
            ),
          ),

          /// Icons aligned with title
          Padding(
            padding: EdgeInsets.only(top: 5.h), // fine tune alignment
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent, // Hides the ripple
                  highlightColor: Colors.transparent, // Hides the click highlight
                  onTap: () {
                    // Notification click event
                    Get.toNamed(Routes.notificationView,);
                  },
                  child: AppIcons.getNotificationIcon(context, size: 38),
                ),
                SizedBox(width: 12.w),
                InkWell(
                  splashColor: Colors.transparent, // Hides the ripple
                  highlightColor: Colors.transparent, // Hides the click highlight
                  onTap: () {
                    // Favourite click event
                    Get.toNamed(Routes.savedProfileView,);
                  },
                  child: AppIcons.getFavouriteIcon(context, size: 38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
