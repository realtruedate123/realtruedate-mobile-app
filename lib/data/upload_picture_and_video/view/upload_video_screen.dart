import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/upload_picture_and_video/upload_video_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadVideoScreen extends StatelessWidget {
  UploadVideoScreen({super.key});

  final UploadVideoController controller = Get.put(UploadVideoController());

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
        backgroundColor: Colors.white, // 👈 set BG color
      extendBodyBehindAppBar: true,
        appBar: TransparentBackAppBar(),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // 🔥 KEY FIX
                  ),
                  child: Column(
                    children: [
                      /// HEADER IMAGE
                      _headerView(context),
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
                          /// Live recording timer
                          // _recordingOverlay(),

                          /// White card
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(28.r)),
                            ),
                            child: Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h,),
                                  AppTextFont(
                                    'Record a video up to 20 seconds long',
                                    font: AppFontType.inter,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: theme.headerTitleColor,
                                  ),

                                  SizedBox(height: 20.h),

                                  // controller.videoFile.value == null
                                  //     ? _recordCard(context)
                                  //     : _uploadedVideoTile(context),
                                  _recordCard(context),
                                  if(controller.videoFile.value != null)...[
                                    SizedBox(height: 20.h),
                                    _uploadedVideoTile(context),

                                    // Obx(() {
                                    //   if (controller.uploadProgress.value == 1.0 &&
                                    //       controller.isVideoUpload.value == false) {
                                    //     return Column(
                                    //       children: [
                                    //         SizedBox(height: 20.h),
                                    //         Center(
                                    //           child: SizedBox(
                                    //             width: 40.w,
                                    //             height: 40.h,
                                    //             child: CircularProgressIndicator(
                                    //               valueColor: AlwaysStoppedAnimation<Color>(
                                    //                 theme.primaryColor,
                                    //               ),
                                    //               strokeWidth: 5.0,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   }
                                    //   return const SizedBox();
                                    // }),


                                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                                  ] else ...[
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.20),
                                  ],

                                  /// Error message
                                  Obx(() => controller.errorMessage.isEmpty
                                      ? const SizedBox()
                                      : Padding(
                                    padding: EdgeInsets.only(top: 12.h),
                                    child: Center(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: TextStyle(
                                          color: controller.isMessage.value ? theme.greenButtonColor : theme.alert,
                                          fontSize: 14.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),

                                  SizedBox(height: 20.h),

                                  _submitButton(),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),

                  )
                  )
                    ],
                  ),
                )
            );
          })
    );
  }

  /// Header
  Widget _headerView(BuildContext context) {
      final theme = AppTheme.of(context);
    return SizedBox(
      height: 320.h, // fixed header height
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
                    'Let AI Understand You Better!',
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
                    'Upload a video introducing yourself. Our AI will analyze your personality to personalize your matches based on your preferences.',
                    style: GoogleFonts.manrope(
                        fontSize: MediaQuery.textScalerOf(context).scale(14),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: theme.headerTitleColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70.h,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ⏱ Recording overlay
  Widget _recordingOverlay() {
    return Positioned(
      top: 90.h,
      left: 0,
      right: 0,
      child: Obx(() {
        if (!controller.isRecording.value) return const SizedBox();

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// blinking red dot
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.3, end: 1),
                duration: const Duration(milliseconds: 700),
                builder: (_, value, __) => Opacity(
                  opacity: value,
                  child: Icon(Icons.circle,
                      color: Colors.red, size: 10),
                ),
                onEnd: () {},
              ),
              SizedBox(width: 8.h),

              /// timer
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.formattedTime,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ➕ Record card
  Widget _recordCard(BuildContext context) {
    final theme = AppTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent, // Hides the ripple
      highlightColor: Colors.transparent, // Hides the click highlight
      onTap: controller.recordVideo,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [8, 6],
          strokeWidth: 1.5,
          color: theme.primaryColor,
          radius: Radius.circular(10.r),
        ),
        child: Container(
          height: 160.h,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(12.r)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcons.getCameraIcon(context, size: 48),
              SizedBox(height: 10.h),
              AppTextFont(
                'Record Video',
                font: AppFontType.inter,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.dark,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🎞 Video preview + scrub
  Widget _uploadedVideoTile(BuildContext context) {
    final theme = AppTheme.of(context);

    return Obx(() {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Container(
          key: ValueKey('upload_tile'),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6FB),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  /// ▶ Play icon
                  SizedBox(
                    height: 40.h,
                    width: 40.w,
                    child: AppIcons.getPlayWhiteIcon(context),
                  ),

                  SizedBox(width: 12),

                  /// File info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextFont(
                          controller.fileName.value,
                          font: AppFontType.inter,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: theme.lightBlueColor,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            AppTextFont(
                              controller.fileSize.value,
                              font: AppFontType.inter,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: theme.hintText,
                            ),
                            SizedBox(width: 8.w),
                            AppIcons.getDotIcon(context, size: 6),
                            SizedBox(width: 8.w),
                            AppTextFont(
                              '${controller.secondsLeft.value} second left',
                              font: AppFontType.inter,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: theme.hintText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ❌ Remove
                  GestureDetector(
                    onTap: controller.removeVideo,
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: controller.uploadProgress.value,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  color: const Color(0xFF6B63A8),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 🚀 Submit
  Widget _submitButton() {
    return SafeArea(
      top: false,
      child: Obx(() {
        final enabled = controller.isMessage.value;

        return PrimaryButton(
          title: 'Submit',
          loading: controller.isLoading.value,
          fontWeight: FontWeight.w600,
          onTap: enabled
              ? () {
            // if (controller.loginKey.currentState!.validate()) {
            // controller.login();
            // }
            print('click $enabled');
            // Get.toNamed(Routes.profileUnderReviewScreen,);
            Get.offAllNamed(
              Routes.authPage,
              arguments: AuthTab.login,
            );

          } : null,
        );
        //   Container(
        //   height: 54,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: enabled ? const Color(0xFF6B63A8) : Colors.grey.shade300,
        //     borderRadius: BorderRadius.circular(30),
        //   ),
        //   alignment: Alignment.center,
        //   child: Text(
        //     'Submit',
        //     style: TextStyle(
        //       color: enabled ? Colors.white : Colors.grey,
        //       fontWeight: FontWeight.w600,
        //       fontSize: 16,
        //     ),
        //   ),
        // );
      }),
    );
  }
}
