import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: title + subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFont(
                  'Discover',
                  font: AppFontType.urbanist,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                ),
                SizedBox(height: 13.h),
                AppTextFont(
                  'Meet RealTrueDate – 100% Real People &\nPictures',
                  font: AppFontType.lato,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.inactiveTabColor,
                  maxLines: 2,
                )
              ],
            ),
          ),

          // _NavIcon(icon: Icons.notifications_none),
          AppIcons.getNotificationIcon(context, size: 38),
          SizedBox(width: 12.h),
          AppIcons.getFavouriteIcon(context, size: 38),
        ],
      ),
    );
  }
}
