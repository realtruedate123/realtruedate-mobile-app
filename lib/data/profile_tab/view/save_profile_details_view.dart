import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/profile_tab/controller/save_profile_details_controller.dart';
import 'package:real_true_date/data/profile_tab/widget/save_profile_app_bar.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/string_class.dart';

class SaveProfileDetailsView extends StatelessWidget {
  final controller = Get.find<SaveProfileDetailsController>();

  SaveProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Obx(() {

      final userInterests = controller.profileData.value.profile?.interests ?? [];
      // final availableInterests = ['Nature', 'Travel', 'Writing'];
      var profileImage = controller.matchData.photoUrl ?? '';
      if(controller.profileData.value.photos?.isNotEmpty ?? false){
        profileImage = controller.profileData.value.photos?.first.photoUrl ?? '';
      }

      return Scaffold(
        extendBodyBehindAppBar: true, // This is key to allow the body to go behind the app bar
        backgroundColor: Colors.black,
        appBar: SaveProfileAppbarWrapper(
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
                imageUrl: profileImage,
              ),
            ),

            /// Bottom Card
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// White Card
                  Container(
                    padding: EdgeInsets.fromLTRB(24.w, 45.h, 24.w, 32.h),
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
                                '${controller.matchData.fullName}, ${controller.matchData.age}',
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

                        if (controller.profileData.value.profile?.interests?.isNotEmpty ?? false) ...[
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
                          )
                        ]
                      ],
                    ),
                  ),

                  /// Floating Buttons (HALF OVER CARD)
                  /*Positioned(
                    top: 10.h,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              // TODO: comment action
                              print('Comment tapped');
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (_) => RejectMatchDialog(),
                              // );
                            },
                            child: AppIcons.getCommentIcon(context, size: 40)
                        ),
                      ],
                    ),
                  ),*/
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