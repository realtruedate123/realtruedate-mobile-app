import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/message_tab/model/chat_model.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class MessageListCell extends StatelessWidget {
  final VoidCallback onTap;
  final ConversationModel chatList;

  const MessageListCell({
    super.key,
    required this.onTap,
    required this.chatList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isDeclined = chatList.status == 'declined';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: isDeclined ? null : onTap, // Disable navigation for declined chats
        child: Opacity(
          // Step 2 Rule: status == "declined" -> grey out row
          opacity: isDeclined ? 0.4 : 1.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                // Avatar + Online Indicator
                Stack(
                  children: [
                    // CircleAvatar(
                    //   radius: 28.r,
                    //   backgroundImage: AssetImage(chatList.recipient?.photoUrl ?? ''),
                    // ),
                    AppCachedImage(
                        imageUrl: chatList.recipient?.photoUrl ?? '',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        borderRadius: 50
                    ),
                    /*if (chatList.recipient?.isOnline ?? false && !isDeclined)
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
                      ),*/
                  ],
                ),

                SizedBox(width: 15.w),

                // Name + Message / Status Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFont(
                        chatList.recipient?.fullName ?? '',
                        font: AppFontType.nunitoSans,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.blackColor,
                      ),
                      SizedBox(height: 5.h),
                      AppTextFont(
                        chatList.lastMessage?.content ?? '',
                        font: AppFontType.nunitoSans,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.darkGrayColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // Trailing Status Badges / Unread Badge
                _buildTrailingBadge(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Evaluates Step 2 Decision Rules for the Cell Trailing Area
  Widget _buildTrailingBadge(BuildContext context) {
    final theme = AppTheme.of(context);

    // 1. Status == "declined" -> "Declined" label
    if (chatList.status == 'declined') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: AppTextFont(
          'Declined',
          font: AppFontType.nunitoSans,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      );
    }

    // 2. Status == "pending" AND is_initiator == true -> "Waiting for reply..." label
    if (chatList.status == 'pending' && chatList.isInitiator!) {
      return AppTextFont(
        'Waiting for reply...',
        font: AppFontType.nunitoSans,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.orange.shade800,
      );
    }

    // 3. Status == "pending" AND is_initiator == false -> "New request" badge
    if (chatList.status == 'pending' && !chatList.isInitiator!) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: AppTextFont(
          'New request',
          font: AppFontType.nunitoSans,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: theme.whiteColor,
        ),
      );
    }

    // 4. Status == "accepted" -> Show unread count circle if > 0
    if (chatList.unreadCount! > 0) {
      return Container(
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
      );
    }

    return const SizedBox.shrink();
  }
}


/*import 'package:flutter/material.dart';
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
*/