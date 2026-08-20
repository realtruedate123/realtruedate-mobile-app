import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/data/splash_on_boarding%20/intro_video.dart';
import 'package:real_true_date/data/splash_on_boarding%20/on_boarding_controller.dart';
import 'package:real_true_date/helper/image_carousel.dart';
import 'package:real_true_date/routes/routes.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  /*
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              onTap: () {
                Get.to(() => IntroVideo());
              },
              child: Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AppIcons.getOnBoardPlayIcon(context, size: 38),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Text Section
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 12.h),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: GoogleFonts.manrope(
                          // textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: MediaQuery.textScalerOf(context).scale(26),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            color: theme.text
                        ),
                      children: [
                        TextSpan(text: 'Let Our ',
                          style: GoogleFonts.manrope(
                              color: theme.lightBlackColor
                          ),
                        ),
                        TextSpan(
                          text: 'AI ',
                          style: GoogleFonts.manrope(
                              color: theme.lightPurpleColor
                          ),
                        ),
                        TextSpan(text: 'Find Your ',
                          style: GoogleFonts.manrope(
                              color: theme.lightBlackColor
                          ),
                        ),
                        TextSpan(
                          text: 'Match',
                          style: GoogleFonts.manrope(
                              color: theme.lightPurpleColor
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    'Meet RealTrueDate – 100% Real People & Pictures No Questions Asked!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      // textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: MediaQuery.textScalerOf(context).scale(12),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: theme.subTitleText
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            /// Image Slider
            GlobalImageCarousel(
              images: [
                CarouselImage.assetPng('assets/png/sd_dummy_one.png'),
                CarouselImage.assetPng('assets/png/sd_dummy_one.png'),
                CarouselImage.assetPng('assets/png/sd_dummy_one.png'),
              ],
              autoPlay: true,
              enlargeCenterPage: true,
              initialPage: 0,
              viewportFraction: 0.8,
              activeDotColor: theme.primaryColor,
              inactiveDotColor: theme.lightGrayColor,
              // height: MediaQuery.of(context).size.height / 1.8,
              // height: double.infinity,
              // controller: controller.slideController
            ),
            SizedBox(height: 10.h),
            /// Bottom Section
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.offAllNamed(
                          Routes.authPage,
                          arguments: AuthTab.login
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.inter(
                          // textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: MediaQuery.textScalerOf(context).scale(16),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            color: theme.primaryColor
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed(
                          Routes.authPage,
                          arguments: AuthTab.signup
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Register',
                        style: GoogleFonts.inter(
                          // textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: MediaQuery.textScalerOf(context).scale(16),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    final theme = AppTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              splashColor: Colors.transparent, // Hides the ripple
              highlightColor: Colors.transparent, // Hides the click highlight
              onTap: () {
                Get.to(() => IntroVideo());
              },
              child: Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AppIcons.getOnBoardPlayIcon(context, size: 38),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Text Section
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 12.h),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        fontSize: MediaQuery.textScalerOf(context).scale(26),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: theme.text,
                      ),
                      children: [
                        TextSpan(
                          text: 'Let Our ',
                          style: GoogleFonts.manrope(
                            color: theme.lightBlackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'AI ',
                          style: GoogleFonts.manrope(
                            color: theme.lightPurpleColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Find Your ',
                          style: GoogleFonts.manrope(
                            color: theme.lightBlackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Match',
                          style: GoogleFonts.manrope(
                            color: theme.lightPurpleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    'Meet RealTrueDate – 100% Real People & Pictures No Questions Asked!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: MediaQuery.textScalerOf(context).scale(12),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: theme.subTitleText,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            /// Image Slider - Fixed height proportion (60% of screen)
            GlobalImageCarousel(
              images: [
                CarouselImage.assetPng('assets/png/m_slider1.png'),
                CarouselImage.assetPng('assets/png/w_slider1.png'),
                CarouselImage.assetPng('assets/png/m_slider2.png'),
                CarouselImage.assetPng('assets/png/w_slider2.png'),
                CarouselImage.assetPng('assets/png/m_slider3.png'),
                CarouselImage.assetPng('assets/png/w_slider3.png'),
                CarouselImage.assetPng('assets/png/m_slider4.png'),
                CarouselImage.assetPng('assets/png/w_slider4.png'),
                CarouselImage.assetPng('assets/png/m_slider5.png'),
                CarouselImage.assetPng('assets/png/w_slider5.png'),
              ],
              height: screenHeight * 0.57,
              autoPlay: true,
              enlargeCenterPage: true,
              initialPage: 0,
              viewportFraction: 0.8,
              activeDotColor: theme.primaryColor,
              inactiveDotColor: theme.lightGrayColor,
            ),

            /// Bottom Section - Use Spacer to push to bottom
            // Spacer(),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.offAllNamed(
                          Routes.authPage,
                          arguments: AuthTab.login,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.inter(
                          fontSize: MediaQuery.textScalerOf(context).scale(16),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed(
                          Routes.authPage,
                          arguments: AuthTab.signup,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Register',
                        style: GoogleFonts.inter(
                          fontSize: MediaQuery.textScalerOf(context).scale(16),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
