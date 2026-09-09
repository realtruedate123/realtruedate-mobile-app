import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_picture_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class UploadPictureScreen extends StatelessWidget {
  UploadPictureScreen({super.key});
  final UploadPhotoController controller = Get.put(UploadPhotoController());

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(backHide: controller.isComing != 'update_video' ? true : false,),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(), // prevents bouncing/overscroll
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // 🔥 KEY FIX
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// HEADER IMAGE
                  SizedBox(
                    height: 260.h, // fixed header height
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        /// HEADER IMAGE
                        Image.asset(
                          AppIcons.headerHalfImagePng,
                          fit: BoxFit.cover,
                        ),

                        /// HEADER TEXT
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppTextFont(
                                  'Upload Picture',
                                  font: AppFontType.manrope,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: theme.headerTitleColor,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h,),
                                AppTextFont(
                                  'Real people, real connections – powered by AI',
                                  font: AppFontType.manrope,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: theme.headerTitleColor,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h,),
                                AppTextFont(
                                  controller.isComing != 'update_video' ?
                                  'Step 3 of 3 – Live Photo Verification' :
                                  'Update Live Photo Verification',
                                  font: AppFontType.manrope,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: theme.headerTitleColor,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 50.h,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),

                  /// WHITE CARD
              Transform.translate(
                offset: Offset(0, -60), // 👈 overlap amount
                child: Container(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Obx(() => _photoGrid(context)),
                      SizedBox(height: 50.h),
                      /// Error message
                      Obx(() => controller.errorMessage.isEmpty
                          ? const SizedBox()
                          : Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: theme.alert,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
                ],
              ),
            ),
          );
        },
      ),
      /// PINNED BUTTON HERE
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Obx(() => _uploadButton()),
      ),
    );
  }


  Widget _photoGrid(BuildContext context) {
      final int photoCount = controller.photoListModel.length;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.maxPhotos,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 17,
          crossAxisSpacing: 12,
          childAspectRatio: 0.60, // matches your screenshot
        ),
        itemBuilder: (context, index) {
          if (index < photoCount) {
            return _imageTile(context, index);
          } else {
            return _addTile(context);
          }
        },
      );
  }

  Widget _addTile(BuildContext context) {
    final theme = AppTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent, // Hides the ripple
      highlightColor: Colors.transparent, // Hides the click highlight
      onTap: controller.openCameraAndUpload,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [8, 6],
          strokeWidth: 1.5,
          color: Colors.grey.shade400,
          radius: Radius.circular(10.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            color: theme.darkGray,
            child: Center(
              child: AppIcons.getShareIcon(
                context,
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageTile(BuildContext context, int index) {
    final controller = Get.find<UploadPhotoController>();
    final theme = AppTheme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// DASHED IMAGE BORDER
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [8, 6],
            strokeWidth: 1.5,
            color: Colors.grey.shade400,
            radius: Radius.circular(10.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: AppCachedImage(
              imageUrl: controller.photoListModel[index].photoUrl ?? '',
              height: double.infinity,
              width: double.infinity,
            )
          ),
        ),

        /// BLUR + GREEN CHECK OVERLAY (CENTER)
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2), // slight dark overlay
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: AppIcons.getOnlyGreenTick(context),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// CLOSE BUTTON
        Positioned(
          top: controller.isComing != 'update_video' ? -8 : -6,
          right: controller.isComing != 'update_video' ? -15 : -6,
          child: GestureDetector(
            onTap: () {
              if(controller.isComing == 'update_video'){
                controller.changePhoto(index);
              }
              else{
                controller.removePhoto(index);
              }
            },
            child: controller.isComing != 'update_video' ?
            AppIcons.getCrossDeleteIcon(context, size: 45) :
            SvgPicture.asset(
                AppIcons.editProfileIcon,
                width: 30.w,
                height: 30.h,
              colorFilter: ColorFilter.mode(theme.blackColor, BlendMode.srcIn),
            )
          ),
        ),
      ],
    );
  }

  Widget _uploadButton() {
    return PrimaryButton(
      title: 'Submit',
      loading: controller.isLoading.value,
      fontWeight: FontWeight.w600,
      onTap: controller.isButtonEnabled
          ? () {
        controller.redirectVideoPage();

      } : null,
    );
  }
}
