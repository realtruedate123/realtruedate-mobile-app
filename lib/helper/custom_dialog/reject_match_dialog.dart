import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class RejectMatchDialog extends StatelessWidget {
  final VoidCallback onReject;

  const RejectMatchDialog({
    super.key,
    required this.onReject,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.h),

                /// Title
                AppTextFont(
                  'Reject Match Request',
                  font: AppFontType.inter,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.blackColor,
                ),
                SizedBox(height: 12.h),

                /// Description
                AppTextFont(
                  'Are you sure you want to reject the match request? '
                      'This action cannot be undone.',
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
                        text: 'Reject',
                        color: theme.alert,
                        onTap: () {
                          // TODO: Reject action
                          Navigator.pop(context);
                          onReject();
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _filledButton(
                        text: 'Cancel',
                        color: theme.greenButtonColor,
                        onTap: () => Navigator.pop(context),
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
