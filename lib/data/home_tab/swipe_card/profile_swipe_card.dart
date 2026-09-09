import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class ProfileSwipeCard extends StatelessWidget {
  final String name;
  final int age;
  final String city;
  final String? imageUrl;
  final bool isVerified;
  final VoidCallback onCancel;
  final VoidCallback onLike;
  final VoidCallback onFavorites;
  final VoidCallback onPhoto;

  const ProfileSwipeCard({
    super.key,
    required this.name,
    required this.age,
    required this.city,
    this.imageUrl,
    required this.isVerified,
    required this.onCancel,
    required this.onLike,
    required this.onFavorites,
    required this.onPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 50.w,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF636363).withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 3,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE
            GestureDetector(
              onTap: onPhoto,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26.r),
                  child: Stack(
                    children: [
                      // Image
                      AppCachedImage(
                        imageUrl: imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300.h,
                      ),

                      // Verified badge
                      if (isVerified)
                        Positioned(
                          top: 5.h,
                          right: 5.w,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            child: AppIcons.getGreenTickIcon(context),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // NAME & AGE
            AppTextFont(
              '${name.capitalize}, $age',
              font: AppFontType.urbanist,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: theme.blackColor,
            ),

            SizedBox(height: 4.h),

            // LOCATION
            // AppTextFont(
            //   city.isNotEmpty ? city : 'Unknown',
            //   font: AppFontType.lato,
            //   fontSize: 12,
            //   fontWeight: FontWeight.w400,
            //   color: theme.inactiveTabColor,
            // ),

            SizedBox(height: 20.h),

            // ACTION BUTTONS
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: AppIcons.getCancelCardIcon(context),
                    onTap: onCancel,
                  ),
                  _actionButton(
                    icon: AppIcons.getLikeCardIcon(context),
                    onTap: onLike,
                  ),
                  _actionButton(
                    icon: AppIcons.getFavouriteCardIcon(context),
                    onTap: onFavorites,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required Widget icon,
    double size = 56,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: size,
        width: size,
        child: icon,
      ),
    );
  }
}