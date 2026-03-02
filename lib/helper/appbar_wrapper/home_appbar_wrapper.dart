import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/routes/routes.dart';

class HomeAppbarWrapper extends StatelessWidget {
  const HomeAppbarWrapper({super.key});

  static double height = 80.h;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      color: Colors.white,
      height: height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
      ),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.06),
      //       blurRadius: 12,
      //       offset: const Offset(0, 4),
      //     ),
      //   ],
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: title + subtitle
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(height: 8.h),
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
                    print('Notification clicked');
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
                    print('Favourite clicked');
                  },
                  child: AppIcons.getFavouriteIcon(context, size: 38),
                ),
              ],
            ),
          ),

          // _NavIcon(icon: Icons.notifications_none),
          // AppIcons.getNotificationIcon(context, size: 38),
          // SizedBox(width: 12.h),
          // AppIcons.getFavouriteIcon(context, size: 38),
        ],
      ),
    );
  }
}
