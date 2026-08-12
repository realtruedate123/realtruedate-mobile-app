import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class ContactSupportCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ContactSupportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: theme.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: Offset(0,2)
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10.w,),
              // Circular soft icon frame panel container
              icon,
              SizedBox(width: 12.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFont(
                    title,
                    font: AppFontType.manrope,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.blackColor,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  AppTextFont(
                    subtitle,
                    font: AppFontType.manrope,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: theme.textDisableColor,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_right,
                color: const Color(0xFF1A1A1A),
                size: 24.r,
              ),
              SizedBox(width: 5.w,)
            ],
          ),
        ),
      ),
    );
  }
}