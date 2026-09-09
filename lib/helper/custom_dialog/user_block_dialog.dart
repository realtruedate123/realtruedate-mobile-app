import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class UserBlockDialog extends StatelessWidget {
  final VoidCallback? onSure;
  final VoidCallback? onCancel;

  const UserBlockDialog({
    super.key,
    this.onSure,
    this.onCancel,
  });


  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),

                /// Title
                AppTextFont(
                  'Block User',
                  font: AppFontType.inter,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                ),
                SizedBox(height: 12.h),

                /// Description
                AppTextFont(
                  'Are you sure you want to block this user?',
                  font: AppFontType.lato,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.headerTitleColor,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: _outlineButton(
                        text: 'Sure',
                        color: theme.alert,
                        onTap: () {
                          // TODO: Reject action
                          Navigator.pop(context);
                          onSure?.call();
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _filledButton(
                        text: 'Cancel',
                        color: theme.greenButtonColor,
                        onTap: () {
                          Navigator.pop(context);
                          onCancel?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- Buttons ----------------

  Widget _outlineButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color),
        ),
        child: AppTextFont(
          text,
          font: AppFontType.inter,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _filledButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AppTextFont(
            text,
            font: AppFontType.inter,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          )
      ),
    );
  }
}
