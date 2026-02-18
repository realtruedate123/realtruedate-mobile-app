import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:get/get.dart';
import 'package:real_true_date/routes/routes.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final bool isHighlight =
        notification.type == NotificationType.connectionRequest ||
            notification.type == NotificationType.uploadVideo;

    return Container(
      color: isHighlight
          ? theme.notificationBGColor
          : Colors.transparent,
      padding: EdgeInsets.all(16),
      child: InkWell(
        splashColor: Colors.transparent, // Hides the ripple
        highlightColor: Colors.transparent, // Hides the click highlight
        onTap: () {
          // click event
          print('clicked ${notification.id}');
          Get.toNamed(Routes.matchesDetailsView,);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(notification.imageUrl),
                ),
                if (notification.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 12.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
              ],
            ),

            SizedBox(width: 12.w),

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title + Subtitle
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: notification.title,
                          style: GoogleFonts.manrope(
                              color: theme.blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14
                          ),
                        ),
                        TextSpan(text:
                        " ${notification.subtitle}",
                          style: GoogleFonts.manrope(
                              color: theme.blackColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),
                  AppTextFont(
                    notification.time,
                    font: AppFontType.urbanist,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.inactiveTabColor,
                  ),

                  SizedBox(height: 8.h),

                  /// Action Buttons based on Type
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (notification.type) {
      case NotificationType.connectionRequest:
        return Row(
          children: [
            _outlineButton(context, "Decline", () {}),
            const SizedBox(width: 10),
            _filledButton(context, "Accept", () {}),
          ],
        );

      case NotificationType.uploadVideo:
        return _outlinePurpleButton(context, "Upload Video", () {});

      case NotificationType.matchAccepted:
        return _outlinePurpleButton(context, "Message", () {});
    }
  }

  Widget _filledButton(BuildContext context, String text, VoidCallback onTap) {
    final theme = AppTheme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      onPressed: onTap,
      child: AppTextFont(
        text,
        font: AppFontType.manrope,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: theme.whiteColor,
      ),
    );
  }

  Widget _outlineButton(BuildContext context, String text, VoidCallback onTap) {
    final theme = AppTheme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        side: BorderSide(color: theme.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      onPressed: onTap,
      child: AppTextFont(
        text,
        font: AppFontType.manrope,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: theme.blackColor,
      ),
    );
  }

  Widget _outlinePurpleButton(BuildContext context, String text, VoidCallback onTap) {
    final theme = AppTheme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          side: BorderSide(color: theme.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        backgroundColor: theme.whiteColor
      ),
      onPressed: onTap,
      child: AppTextFont(
        text,
        font: AppFontType.inter,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: theme.primaryColor,
      ),
    );
  }
}

enum NotificationType {
  connectionRequest,
  uploadVideo,
  matchAccepted,
}

class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String imageUrl;
  final NotificationType type;
  final bool isOnline;

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imageUrl,
    required this.type,
    this.isOnline = false,
  });
}
