import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_true_date/helper/app_text_font.dart';

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

                SizedBox(height: 10.h),

                /// Action Buttons based on Type
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (notification.type) {
      case NotificationType.connectionRequest:
        return Row(
          children: [
            _outlineButton("Decline", () {}),
            const SizedBox(width: 10),
            _filledButton("Accept", () {}),
          ],
        );

      case NotificationType.uploadVideo:
        return _outlinePurpleButton("Upload Video", () {});

      case NotificationType.matchAccepted:
        return _outlinePurpleButton("Message", () {});
    }
  }

  Widget _filledButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5D5494),
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
        color: Colors.white,
      ),
    );
  }

  Widget _outlineButton(String text, VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFB0B0B0)),
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
        color: Colors.black,
      ),
    );
  }

  Widget _outlinePurpleButton(String text, VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF5D5494)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      onPressed: onTap,
      child: AppTextFont(
        text,
        font: AppFontType.inter,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF5D5494),
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
