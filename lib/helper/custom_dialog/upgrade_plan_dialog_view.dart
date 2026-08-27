import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/login_signup/widgets/primary_button.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class UpgradePlanDialogView extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const UpgradePlanDialogView({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = "Upgrade Plan",
    this.cancelText = "Ok",
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Dialog(
      backgroundColor: theme.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        // height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 10.h),
        child: Stack(
          children: [
            /// Close Icon
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: AppIcons.getCloseRedIcon(context),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 25.h),
                AppTextFont(
                  'Oops!',
                  font: AppFontType.inter,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.text,
                  maxLines: 1,
                ),
                SizedBox(height: 15.h),
                AppTextFont(
                  title,
                  font: AppFontType.inter,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                  maxLines: 2,
                ),
                SizedBox(height: 15.h),
                AppTextFont(
                  message,
                  font: AppFontType.inter,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.hintText,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryButton(
                    title: confirmText,
                    fontWeight: FontWeight.w600,
                    onTap: onConfirm,
                  ),
                )
                // ElevatedButton(
                //   onPressed: onConfirm,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: theme.buttonBG,
                //     // minimumSize: Size(131.w, 45.h),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(24.r),
                //     ),
                //   ),
                //   child: Text(
                //     confirmText,
                //     style: TextStyle(
                //       fontSize: MediaQuery.textScalerOf(context).scale(18.0),
                //       fontWeight: FontWeight.w500,
                //       fontFamily: 'Inter',
                //       color: theme.buttonText,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
