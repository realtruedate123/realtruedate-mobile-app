import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/matches_tab/model/matches_list_model.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class MatchCardListCell extends StatelessWidget {
  final MatchList match;
  final VoidCallback? onTap;

  const MatchCardListCell({
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
                    child: AppCachedImage(
                      imageUrl: match.user?.photoUrl ?? '',
                    )
                  ),

                  /// Match % (Top Center)
                  Positioned(
                    top: 10.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // adjust blur strength
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 11.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: theme.whiteColor,
                                width: 1,
                              ),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: AppTextFont(
                              "${match.matchPercentage}% Match",
                              font: AppFontType.urbanist,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Verified badge (Bottom Left)
                  if (match.user?.isVerified == true)
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
                    "${match.user?.firstName}, ${match.user?.age}",
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
          /// Location
          Center(
            child: AppTextFont(
              '${match.user?.city}, ${match.user?.state}',
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
