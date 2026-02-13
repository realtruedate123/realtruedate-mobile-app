import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class GenderToggle extends StatelessWidget {
  final AuthController controller;

  const GenderToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 40.h,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            _genderButton(
              context: context,
              title: 'Male',
              isSelected: controller.selectedGender.value == 'Male',
              onTap: () => controller.setGender('Male'),
            ),
            SizedBox(width: 20.w,),
            _genderButton(
              context: context,
              title: 'Female',
              isSelected: controller.selectedGender.value == 'Female',
              onTap: () => controller.setGender('Female'),
            ),
            // SizedBox(width: 20.w,),
            // _genderButton(
            //   context: context,
            //   title: 'Other',
            //   isSelected: controller.selectedGender.value == 'Other',
            //   onTap: () => controller.setGender('Other'),
            // ),
          ],
        ),
      );
    });
  }

  Widget _genderButton({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: 115.w, // 🔥 fixed width (adjust if needed)
      height: 40.h,
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: theme.border),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent, // Hides the ripple
          highlightColor: Colors.transparent, // Hides the click highlight
          borderRadius: BorderRadius.circular(40.r),
          onTap: onTap,
          child: Center(
            child: AppTextFont(
              title,
              font: AppFontType.manrope,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : theme.iconTintColor,
            ),
          ),
        ),
      ),
    );
  }
}
