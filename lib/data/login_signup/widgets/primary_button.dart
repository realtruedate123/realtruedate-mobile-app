import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool loading;
  final FontWeight fontWeight;
  final double fontSize;
  final bool cornerRadius;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 16,
    this.cornerRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          onTap == null ? theme.segmentBGColor : theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius == false ? 25.r : 14.r),
          ),
        ),
        child: loading
            ? SizedBox(
          height: 22.h,
          width: 22.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: Colors.white,
          ),
        )
            : AppTextFont(
          title,
          font: AppFontType.inter,
          fontSize: MediaQuery.textScalerOf(context).scale(fontSize),
          fontWeight: fontWeight,
          color: onTap == null ? theme.textDisableColor : Colors.white,
        )
        // Text(
        //   title,
        //   style: TextStyle(
        //     color: onTap == null ? theme.textDisableColor : Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
