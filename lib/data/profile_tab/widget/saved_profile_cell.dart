import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/model/saved_profile_model.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class SavedProfileCell extends StatelessWidget {
  final FavoriteModel match;
  final VoidCallback? onTap;

  const SavedProfileCell({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image Card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                children: [
                  /// Image
                  AspectRatio(
                      aspectRatio: 3 / 4,
                      // child: Image.asset(AppIcons.dummyProfileCard, fit: BoxFit.cover,),
                      child: AppCachedImage(
                        imageUrl: match.photoUrl ?? '',
                      )
                    // Image.network(
                    //   match.imageUrl,
                    //   fit: BoxFit.cover,
                    // ),
                  ),

                  Positioned(
                    top: 2.h,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      child: AppIcons.getStarProfileIcon(context),
                    ),
                  ),

                  /// Verified badge (Bottom Left)
                  if (match.isVerified ?? false)
                    Positioned(
                      bottom: 2.h,
                      left: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        child: AppIcons.getGreenTickIcon(context),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),

          /// Name + Online dot
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AppTextFont(
                    "${match.fullName}, ${match.age}",
                    font: AppFontType.urbanist,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.blackColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // truncates with "..."
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 5.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Color(0xff13E398),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // SizedBox(height: 6.h),

          /// Location
          Center(
            child: AppTextFont(
              '',
              font: AppFontType.lato,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: theme.inactiveTabColor,
            ),
          ),
        ],
      ),
    );
  }
}
