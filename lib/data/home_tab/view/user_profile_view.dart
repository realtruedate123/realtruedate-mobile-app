import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/home_tab/controller/user_profile_controller.dart';
import 'package:real_true_date/data/home_tab/widget/matches_popup.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/appbar_wrapper/user_profile_appbar_wrapper.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/custom_dialog/reject_match_dialog.dart';
import 'package:real_true_date/helper/string_class.dart';

class UserProfileDetailsScreen extends StatelessWidget {
  final controller = Get.find<UserProfileController>();

  UserProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final userInterests = controller.profileData.value.profile?.interests ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true, // This is key to allow the body to go behind the app bar
      backgroundColor: Colors.black,
      appBar: UserProfileAppbarWrapper(
        isStarFilled: controller.isFavorite,
        onStarTap: controller.toggleFavorite,
        showShadow: true,
      ),
      body: Stack(
        children: [
          /// Profile Image
          Positioned.fill(
            // child: Image.asset(
            //   AppIcons.dummyProfileDetailsCard,
            //   fit: BoxFit.contain,
            //   alignment: Alignment.topCenter,
            // ),
            child: AppCachedImage(
              imageUrl: controller.matchData.photoUrl ?? '',
            ),
          ),

          /// Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// White Card
                Padding(
                  padding: EdgeInsets.only(top: 32.r),
                  child: Container(
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
                                '${controller.matchData.firstName}, ${controller.matchData.age}',
                                font: AppFontType.urbanist,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: theme.dark,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4.h),
                              AppTextFont(
                                '${controller.cityName.value}, ${controller.stateName.value}',
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
                          '',
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
                          children: availableInterests.map((interest) {
                            final isSelected = userInterests.contains(interest);
                            return _interestChip(
                              context,
                              interest,
                              filled: isSelected,
                            );
                          }).toList(),
                        ),

                        /*Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            _interestChip(context, 'Nature', filled: true),
                            _interestChip(context, 'Travel'),
                            _interestChip(context, 'Writing'),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ),

                /// Floating Buttons (HALF OVER CARD)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // TODO: cancel action
                            print('Cancel tapped');
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => RejectMatchDialog(
                                onReject: () {
                                  controller.swipeCardApiCall('left');
                                },
                              ),
                            );
                          },
                          child: AppIcons.getCancelCardIcon(context, size: 60)
                      ),
                      SizedBox(width: 24.w),
                      GestureDetector(
                          onTap: () {
                            // TODO: liked action
                            print('Liked tapped');
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => MatchPopup(
                                userId: controller.matchData.userId,
                                name: controller.matchData.firstName,
                                age: controller.matchData.age,
                                city: controller.matchData.city ?? '',
                                state: controller.matchData.state ?? '',
                                photoUrl: controller.matchData.photoUrl ?? '',
                                isVerified: controller.matchData.isVerified,
                                  userProfileUrl: controller.userProfileUrl,
                                onMessage: () {
                                  print('message');
                                },
                              ),
                            );
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