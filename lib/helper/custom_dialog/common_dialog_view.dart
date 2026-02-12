import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_theme.dart';

class CommonDialogView extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const CommonDialogView({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = "Yes",
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
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   title,
            //   style: TextStyle(
            //     fontSize: MediaQuery.textScalerOf(context).scale(20.0),
            //     fontWeight: FontWeight.w600,
            //     fontFamily: 'Inter',
            //     color: theme.blackColor,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(height: 15.h),
            Text(
              message,
              style: TextStyle(
                fontSize: MediaQuery.textScalerOf(context).scale(16.0),
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                color: theme.text,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onCancel ?? () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    minimumSize: Size(131.w, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      side: BorderSide(color: theme.border),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    cancelText,
                    style: TextStyle(
                      fontSize: MediaQuery.textScalerOf(context).scale(18.0),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: theme.whiteColor,
                    ),
                  ),
                ),
                // SizedBox(width: 10.w),
                // ElevatedButton(
                //   onPressed: onConfirm,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: theme.buttonBG,
                //     minimumSize: Size(131.w, 45.h),
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
                //       color: theme.buttontext,
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
