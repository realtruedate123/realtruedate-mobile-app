import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_header.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/data/otp_reset_password/controller/otp_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:real_true_date/helper/transparent_appbar.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // Remove default AppBar background
      extendBodyBehindAppBar: true,
      appBar: TransparentBackAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIcons.headerImagePng),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              /// Header Title View
              AuthHeader(
                title: 'OTP Verification',
                subtitle: 'We have sent the Verification code to\n${maskEmail(controller.emailId)}',
                height: 155,
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.r),
                      ),
                    ),
                    child: SafeArea(
                      top: false, // only bottom safe area inside
                      child: Column(
                        children: [
                          /// Forgot password View
                          SizedBox(height: 15.h,),
                          OtpTextField(
                            numberOfFields: 4,
                            borderColor: theme.border,
                            fillColor: theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(14.r)),
                            fieldHeight: 56.h,
                            fieldWidth: 56.w,
                            margin: EdgeInsets.only(right: 15.w),
                            borderWidth: 1.w,
                            contentPadding: EdgeInsetsGeometry.all(15),
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              //handle validation or checks here
                              print('Enter OTP ${code.length}');
                              controller.onOtpChanged(code);
                            },
                            textStyle: TextStyle(
                              fontSize: 20.sp, // 🔥 THIS controls box height visually
                              fontWeight: FontWeight.w500,
                            ),
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode){
                              print('OTP $verificationCode');
                              controller.onOtpChanged(verificationCode);
                            }, // end onSubmit
                          ),
                          SizedBox(height: 20.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              AppTextFont(
                                'Didn’t receive the code?',
                                font: AppFontType.manrope,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: theme.hintText,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  // Code to execute when the button is pressed
                                  print('Text button pressed');
                                  controller.reSendOTP();
                                },
                                child: AppTextFont(
                                  ' Resend',
                                  font: AppFontType.manrope,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: theme.primaryColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 50.h,),
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
                          SizedBox(height: 20.h,),
                          /// Send OTP button
                          Obx(
                                () => PrimaryButton(
                              title: 'Verify OTP',
                              loading: controller.isLoading.value,
                              fontWeight: FontWeight.w600,
                              onTap: controller.isOtpValid.value
                                  ? () {
                                // if (controller.loginKey.currentState!.validate()) {
                                // controller.login();
                                // }
                                print('click ${controller.verifyOtp}');
                                controller.verifyOtp();

                              } : null,
                            ),
                          ),
                          SizedBox(height: 10.h,)
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
