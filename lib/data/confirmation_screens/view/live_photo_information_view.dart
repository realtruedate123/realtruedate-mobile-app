import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/confirmation_screens/controller/LivePhotoInformationController.dart';
import 'package:get/get.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LivePhotoInformationView extends StatelessWidget {
  const LivePhotoInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor, // app theme background
      appBar: AppBar(
        backgroundColor: theme.whiteColor,
        elevation: 0,
        leading: Container(), // or SizedBox.shrink()
      ),
      body: GetBuilder<LivePhotoInformationController>(
        builder: (LivePhotoInformationController controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// Top Icon
                Icon(
                  controller.currentStep.icon ?? Icons.photo_camera_rounded,
                  size: 80,
                  color: theme.primaryColor,
                ),

                SizedBox(height: 40.h),

                /// Title
                Text(
                  controller.currentStep.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFontType.inter.toString(),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.headerTitleColor,
                  ),
                ),

                SizedBox(height: 20.h),

                /// Description
                Text(
                  controller.currentStep.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFontType.inter.toString(),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: theme.subTitleText,
                  ),
                ),

                Spacer(),

                /// Next Button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    title: controller.currentStep.buttonText,
                    fontWeight: FontWeight.w600,
                    onTap: controller.nextStep,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}