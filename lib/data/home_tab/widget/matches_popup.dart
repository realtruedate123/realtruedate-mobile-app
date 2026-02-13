import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchPopup extends StatelessWidget {
  const MatchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: theme.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(height: 20.h),

                /// Overlapping Images
                SizedBox(
                  height: 160.h,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      /// Left Image
                      Positioned(
                        left: 40,
                        top: 0,
                        child: _buildProfileImage(
                          context,
                          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=500&q=80",
                        ),
                      ),

                      /// Right Image
                      Positioned(
                        right: 40,
                        top: 40,
                        child: _buildProfileImage(
                          context,
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&q=80",
                        ),
                      ),

                      /// Heart Icon
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: theme.whiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: AppIcons.getHeartOnly(context, size: 27)
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),
                AppTextFont(
                  'IT’S A MATCH!',
                  font: AppFontType.inter,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
                SizedBox(height: 16.h),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Amanda Sugar, ",
                        style: GoogleFonts.inter(
                            color: theme.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 24
                        ),
                      ),
                      TextSpan(
                        text: "24",
                        style: GoogleFonts.inter(
                            color: theme.blackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 24
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                AppTextFont(
                  'Junior Chef',
                  font: AppFontType.inter,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.inactiveTabColor,
                ),

                SizedBox(height: 30.h),

                /// Button
                PrimaryButton(
                  title: 'Send a Message',
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    print('click');
                    Get.back();
                  },
                ),
              ],
            ),
          ),

          /// Close Button
          Positioned(
            top: 20,
            right: 2,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: AppIcons.getCrossDeleteIcon(context, size: 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, String image) {
    final theme = AppTheme.of(context);

    return Container(
      height: 120.h,
      width: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.primaryColor,
          width: 4.w,
        ),
      ),
      child: ClipOval(
        child: AppCachedImage(
          imageUrl: image,
          height: 120.h,
          width: 120.w,
        )
      ),
    );
  }

/*
  Widget _buildProfileImage(String image) {
    return Container(
      height: 110.h,
      width: 110.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xff6C63FF),
          width: 4,
        ),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  */
}
