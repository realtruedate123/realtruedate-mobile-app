import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_true_date/data/notifications/model/notification_list_model.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/date_time.dart';
import 'package:real_true_date/routes/routes.dart';

class NotificationTile extends StatelessWidget {
  final NotificationObject notification;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onMessage;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onAccept,
    this.onDecline,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final bool isHighlight =
        notification.notificationType == 'connect_request' &&
            notification.conversationStatus == 'pending';

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
          // Get.toNamed(Routes.matchesDetailsView,);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(notification.senderPhoto ?? ''),
                ),
               /* if (notification.isOnline)
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
                  )*/
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
                        " ${notification.body}",
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
                    TimeAgoHelper.format(notification.createdAt),
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

  Widget _buildActionButtons(BuildContext context){
    final bool isHighlight =
        notification.notificationType == 'connect_request' &&
            notification.conversationStatus == 'pending';

    return isHighlight ?
    Row(
      children: [
        _outlineButton(context, "Decline", onDecline ?? () {},),
        const SizedBox(width: 10),
        _filledButton(context, "Accept", onAccept ?? () {},),
      ],
    )
        : _outlinePurpleButton(context, "Message", onMessage ?? () {},);
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