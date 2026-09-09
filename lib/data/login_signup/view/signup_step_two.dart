import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:get/get.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/helper/gender_toggle.dart';

class SignupStepTwo extends GetView<AuthController> {
  const SignupStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Form(
      key: controller.signupStepTwoKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5.h,),
          /// Name
          AuthInput(
              hint: 'Name',
              controller: controller.nameCtrl,
              icon: AppIcons.getPeopleIcon(context),
          ),
          SizedBox(height: 5.h,),
          /// Email
          Obx(() => AuthInput(
              hint: 'Email Address',
              controller: controller.singUpEmailCtrl,
              icon: AppIcons.getEmailIcon(context),
              keyboardType: TextInputType.emailAddress,
            errorText: controller.signUpEmailError.value,
          ),
          ),
          SizedBox(height: 5.h,),
          /// Password
          Obx(() => AuthInput(
              hint: 'Password',
              controller: controller.singUpPasswordCtrl,
              icon: AppIcons.getPasswordIcon(context),
              isPassword: true,
            errorText: controller.signUpPasswordError.value,
          ),
          ),
          SizedBox(height: 5.h,),
          GenderToggle(controller: controller),

          // const Spacer(),
          SizedBox(height: 50.h,),
          /// Error message
          Obx(() => controller.errorMessageStepTwo.isEmpty
              ? const SizedBox()
              : Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
            child: Text(
              controller.errorMessageStepTwo.value,
              style: TextStyle(
                color: theme.alert,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          )),
          SizedBox(height: 20.h,),
          /// Create button
          Obx(() => PrimaryButton(
            title: 'Create Account',
            onTap: controller.isSecondFormValid.value
                ? () {
              print('Signup two allowed');
              controller.submitSignup();
            }
                : null,
          )),
          SizedBox(height: 15.h,),
          alreadyHaveAccountButton(context),
          SizedBox(height: 5.h,),
        ],
      ),
    );
  }

  Widget alreadyHaveAccountButton(BuildContext context) {
    final theme = AppTheme.of(context);

    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: MediaQuery.textScalerOf(context).scale(15),
            color: theme.headerTitleColor,
          ),
          children: [
            TextSpan(
              text: 'Already have Account? ',
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: theme.lightPurpleColor,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  controller.currentTab.value = AuthTab.login;
                },
            ),
          ],
        ),
      ),
    );
  }
}
