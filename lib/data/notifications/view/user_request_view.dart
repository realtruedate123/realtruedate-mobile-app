import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/home_tab/widget/matches_popup.dart';
import 'package:real_true_date/data/notifications/controller/user_request_controller.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/appbar_wrapper/user_profile_appbar_wrapper.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/custom_dialog/reject_match_dialog.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';

class UserRequestView extends StatelessWidget {
  final controller = Get.find<UserRequestController>();

  UserRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final userInterests = controller.profileData.value.profile?.interests ?? [];
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          ),
        );
      }
        return Scaffold(
          extendBodyBehindAppBar: true, // This is key to allow the body to go behind the app bar
          backgroundColor: Colors.black,
          appBar: UserProfileAppbarWrapper(
            isStarFilled: controller.isFavorite,
            onStarTap: controller.toggleFavorite,
            showShadow: true,
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              /// Profile Image
              Positioned.fill(
                child: AppCachedImage(
                  imageUrl: controller.matchData.senderPhoto ?? '',
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
                                    '${controller.matchData.senderName}, ${controller.profileData.value.age}',
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
                              controller.profileData.value.bio ?? '',
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
                          ],
                        ),
                      ),
                    ),

                    /// Floating Buttons (HALF OVER CARD)
                    if(controller.typeStatus.value)...[
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
                                        print('cancel');
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
                                      userId: controller.matchData.conversationId ?? '',
                                      name: controller.matchData.senderName ?? '',
                                      age: controller.profileData.value.age ?? 0,
                                      city: controller.profileData.value.city ?? '',
                                      state: controller.profileData.value.state ?? '',
                                      photoUrl: controller.matchData.senderPhoto ?? '',
                                      isVerified: controller.profileData.value.isVerified ?? false,
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
                    ] else ...[
                      Positioned(
                        top: 40.h,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // TODO: comment action
                                  print('Comment tapped');
                                  Get.toNamed(Routes.chatView, arguments: {
                                    'conversation_id': controller.matchData.conversationId ?? ''
                                  });
                                },
                                child: AppIcons.getCommentIcon(context, size: 40)
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        );
    });
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