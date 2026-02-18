import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/message_tab/controller/message_tab_controller.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class MessageListCell extends StatelessWidget {
  final VoidCallback onTap;
  final ChatModel chatList;

  const MessageListCell({
    super.key,
    required this.onTap,
    required this.chatList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent, // Hides the ripple
        highlightColor: Colors.transparent, // Hides the click highlight
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundImage: AssetImage(chatList.image),
                  ),

                  // Online Dot
                  if (chatList.isOnline)
                    Positioned(
                      bottom: 2.h,
                      right: 2.w,
                      child: Container(
                        height: 16.h,
                        width: 16.w,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 15.w),

              // Name + Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextFont(
                      chatList.name,
                      font: AppFontType.nunitoSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.blackColor,
                    ),
                    SizedBox(height: 5.h),
                    AppTextFont(
                      chatList.message,
                      font: AppFontType.nunitoSans,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.darkGrayColor,
                    ),
                  ],
                ),
              ),

              // Unread Badge
              if (chatList.unreadCount > 0)
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: theme.messageCountColor,
                    shape: BoxShape.circle,
                  ),
                  child: AppTextFont(
                    chatList.unreadCount.toString(),
                    font: AppFontType.nunitoSans,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.whiteColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
