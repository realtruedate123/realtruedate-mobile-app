import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:real_true_date/data/login_signup/widgets/auth_input.dart';
import 'package:real_true_date/data/login_signup/widgets/input_container.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:real_true_date/helper/icon_checkbox.dart';

class SignupStepOne extends GetView<AuthController> {
  const SignupStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Form(
      key: controller.signupStepOneKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h,),
          /// Name
          AuthInput(
            hint: 'Name',
            controller: controller.nameCtrl,
            icon: AppIcons.getPeopleIcon(context),
          ),
          SizedBox(height: 5.h,),
          /// DOB picker
          InputContainer(
            height: 58.h,
            child: InkWell(
              splashColor: Colors.transparent, // Hides the ripple
              highlightColor: Colors.transparent, // Hides the click highlight
              onTap: () => showDobPicker(context, controller),
              child: Obx(() => Row(
                children: [
                  AppIcons.getBirthdayIcon(context, color: controller.dob.value == null
                      ? theme.iconTintColor
                      : theme.primaryColor),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      controller.dob.value == null
                          ? 'When your Birthday?'
                          : DateFormat('dd MM yyyy').format(controller.dob.value!),
                      style: TextStyle(
                        fontSize: MediaQuery.textScalerOf(context).scale(15),
                        color: controller.dob.value == null
                            ? theme.iconTintColor
                            : theme.primaryColor,
                      ),
                    ),
                  ),
                  AppIcons.getCalendarIcon(context),
                ],
              )),
            ),
          ),
          SizedBox(height: 20.h,),
          /// Email
          Obx(() => AuthInput(
            hint: 'Email Address',
            controller: controller.singUpEmailCtrl,
            icon: AppIcons.getEmailIcon(context),
            keyboardType: TextInputType.emailAddress,
            errorText: controller.signUpEmailError.value,
          ),
          ),

          /// Select Your Gender picker
          InputContainer(
            height: 58.h,
            child: InkWell(
              splashColor: Colors.transparent, // Hides the ripple
              highlightColor: Colors.transparent, // Hides the click highlight
              onTap: () => showSelectYourGenderPicker(context, controller),
              child: Obx(() => Row(
                children: [
                  AppIcons.getPeopleIcon(context, color: controller.selectedGender.value == null
                      ? theme.iconTintColor
                      : theme.primaryColor),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      controller.selectedGender.value ?? 'Gender',
                      style: TextStyle(
                        fontSize: MediaQuery.textScalerOf(context).scale(15),
                        color: controller.selectedGender.value == null
                            ? theme.iconTintColor
                            : theme.primaryColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AppIcons.getDownArrowIcon(
                      context,
                      size: 18,
                    ),
                  ),
                ],
              )),
            ),
          ),
          SizedBox(height: 20.h,),

          /// Password
          Obx(() => AuthInput(
            hint: 'Password',
            controller: controller.singUpPasswordCtrl,
            icon: AppIcons.getPasswordIcon(context),
            isPassword: true,
            errorText: controller.signUpPasswordError.value,
          ),
          ),
          // SizedBox(height: 5.h,),

          /// Looking Gender picker
          InputContainer(
            height: 58.h,
            child: InkWell(
              splashColor: Colors.transparent, // Hides the ripple
              highlightColor: Colors.transparent, // Hides the click highlight
              onTap: () => showGenderPicker(context, controller),
              child: Obx(() => Row(
                children: [
                  AppIcons.getPeopleIcon(context, color: controller.lookingGender.value == null
                      ? theme.iconTintColor
                      : theme.primaryColor),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      controller.lookingGender.value ?? 'Looking for (Male/Female)',
                      style: TextStyle(
                        fontSize: MediaQuery.textScalerOf(context).scale(15),
                        color: controller.lookingGender.value == null
                            ? theme.iconTintColor
                            : theme.primaryColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AppIcons.getDownArrowIcon(
                      context,
                      size: 18,
                    ),
                  ),
                ],
              )),
            ),
          ),
          SizedBox(height: 20.h,),

          /// Select your gender
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: AppTextFont(
          //     'Select your gender',
          //     font: AppFontType.manrope,
          //     fontSize: 13,
          //     fontWeight: FontWeight.w500,
          //     color: theme.inactiveTabColor,
          //     maxLines: 1,
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // SizedBox(height: 8.h,),
          // GenderToggle(controller: controller),

          // SizedBox(height: 25.h,),
          /// Zipcode
          // AuthInput(
          //     hint: 'Enter your zipcode',
          //     controller: controller.zipCtrl,
          //     icon: AppIcons.getPlaceIcon(context),
          //     keyboardType: TextInputType.number
          // ),


          SizedBox(height: 20.h,),
          /// T&C
          Obx(() =>
              Row(
            children: [
              SizedBox(width: 10.w,),
              SvgIconCheckbox(
                value: controller.isChecked.value,
                checkedSvg: AppIcons.checkMark,
                uncheckedSvg: AppIcons.uncheckMark,
                onChanged: (v) {
                  controller.isChecked.value = v;
                  controller.toggleTC(v);
                },
              ),
              SizedBox(width: 5.w,),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: theme.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp
                    ),
                    children: [
                      TextSpan(text: 'I agree to the ', style: TextStyle(color: theme.dark)),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Terms of Service
                            controller.openTermPolicy('terms');
                          },
                      ),
                      TextSpan(text: ' and ', style: TextStyle(color: theme.dark)),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Terms of Service
                            controller.openTermPolicy('policy');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    ),
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
          Obx(() => PrimaryButton(
            title: 'Create Account',
            onTap: controller.isFormValid.value
                ? () {
              print('Signup one allowed');
              // controller.nextSignupStep();
              controller.submitSignup();
            }
                : null,
          )),
          SizedBox(height: 15.h,),
          alreadyHaveAccountButton(context),
          SizedBox(height: 10.h,),
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

  void showGenderPicker(BuildContext context, AuthController controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Male', 'Female'].map((e) {
              return ListTile(
                title: Text(e),
                onTap: () {
                  controller.setLookingGender(e);
                  Get.back();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void showSelectYourGenderPicker(BuildContext context, AuthController controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Male', 'Female'].map((e) {
              return ListTile(
                title: Text(e),
                onTap: () {
                  controller.setSelectYourGender(e);
                  Get.back();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void showDobPicker(BuildContext context, AuthController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag handle
              SizedBox(height: 5.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),

              /// Header with Close
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 48.w),
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 200.h,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                  controller.dob.value ?? DateTime(2000),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: controller.setDob,
                ),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }
}

