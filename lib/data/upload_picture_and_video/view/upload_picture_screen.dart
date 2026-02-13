import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_picture_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/gif_loader_view.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';
import 'package:real_true_date/routes/routes.dart';

class UploadPictureScreen extends StatelessWidget {
  UploadPictureScreen({super.key});
  final UploadPhotoController controller = Get.put(UploadPhotoController());

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // 🔥 KEY FIX
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// HEADER IMAGE
                  SizedBox(
                    height: 250, // fixed header height
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
                          // bottom: false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Upload Picture',
                                  style: GoogleFonts.manrope(
                                      fontSize: MediaQuery.textScalerOf(context).scale(32),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      color: theme.headerTitleColor
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h,),
                                Text(
                                  'Real people, real connections – powered by AI',
                                  style: GoogleFonts.manrope(
                                      fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color: theme.headerTitleColor
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 25.h,)
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

                      SizedBox(height: 20.h),
                      Obx(() => _uploadButton()),
                      // SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),

                  /// Loader Overlay
                  // Obx(() {
                  //   return controller.isLoading.value
                  //       ? Container(
                  //     color: Colors.black.withOpacity(0.4),
                  //     child: Center(
                  //       child: Stack(
                  //         children: [
                  //           GifLoaderView(isLoading: controller.isLoading.value),
                  //         ],
                  //       )
                  //     ),
                  //   )
                  //       : const SizedBox();
                  // }),

                ],
              ),
            ),
          );
        },
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
          crossAxisCount: 3,
          mainAxisSpacing: 17,
          crossAxisSpacing: 12,
          childAspectRatio: 0.55, // matches your screenshot
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
    // final controller = Get.find<UploadPhotoController>();
    final theme = AppTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent, // Hides the ripple
      highlightColor: Colors.transparent, // Hides the click highlight
      onTap: controller.captureImage,
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
            // Image.network(
            //   controller.photoListModel[index],
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) {
            //     return Icon(Icons.broken_image);
            //   },
            //   loadingBuilder: (context, child, loadingProgress) {
            //     if (loadingProgress == null) return child;
            //     return Center(child: CircularProgressIndicator());
            //   },
            // ),
          ),
          // child: ClipRRect(
          //   borderRadius: BorderRadius.circular(10.r),
          //   child: Container(
          //     width: double.infinity,
          //     height: double.infinity,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: FileImage(controller.photos[index]),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
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
          top: -8,
          right: -15,
          child: GestureDetector(
            onTap: () => controller.removePhoto(index),
            child: AppIcons.getCrossDeleteIcon(context, size: 45)
          ),
        ),
      ],
    );
  }

  Widget _uploadButton() {
    // final controller = Get.find<UploadPhotoController>();

    String buttonText;

    if (controller.isButtonEnabled) {
      buttonText = controller.isVideoVerify ? 'Back to Login' : 'Upload Video';
    } else if (controller.isVideoVerify) {
      buttonText = 'Back to Login';
    } else {
      buttonText = 'View Singles';
    }

    return PrimaryButton(
      // title: controller.isButtonEnabled ? 'Upload Video' : 'View Singles',
      title: buttonText,
      loading: controller.isLoading.value,
      fontWeight: FontWeight.w600,
      onTap: controller.isButtonEnabled
          ? () {
        // if (controller.loginKey.currentState!.validate()) {
        // controller.login();
        // }
        print('click ${controller.isButtonEnabled}');
        controller.redirectVideoPage();

      } : null,
    );

    //   SizedBox(
    //   width: double.infinity,
    //   height: 52,
    //   child: ElevatedButton(
    //     onPressed: controller.isButtonEnabled ? () {
    //       print('Selected images: ${controller.photos.length}');
    //     } : null,
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: controller.isButtonEnabled
    //           ? const Color(0xFF6B63A8)
    //           : Colors.grey.shade300,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //     ),
    //     child: Text(
    //       'View Singles',
    //       style: TextStyle(fontSize: 16),
    //     ),
    //   ),
    // );
  }
}
