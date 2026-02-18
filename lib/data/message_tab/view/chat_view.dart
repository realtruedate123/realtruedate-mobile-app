import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/message_tab/controller/chat_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_true_date/helper/app_text_font.dart';

class ChatView extends StatelessWidget {
  final controller = Get.put(ChatController());
  ChatView({super.key});

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _chatHeader(context),
            SizedBox(height: 10.h),
            Text(
              "Today",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16
              ),
            ),
            SizedBox(height: 10.h),

            /// Messages
            Expanded(
              child: Container(
                color: theme.offWhiteBGColor,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return _messageBubble(context ,controller.messages[index]);
                  },
                ),
              ),
            ),

            /// Input Field
            _messageInput(context),
          ],
        ),
      ),
    );
  }
}

Widget _chatHeader(BuildContext context) {
  final theme = AppTheme.of(context);

  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30.r),
      ),
    ),
    child: Row(
      children: [
        InkWell(
          splashColor: Colors.transparent, // Hides the ripple
          highlightColor: Colors.transparent, // Hides the click highlight
          onTap: () {
            // Fav click event
            print('clicked');
            Get.back();
          },
          child: AppIcons.getLeftArrow(context, size: 30),
        ),
        SizedBox(width: 10.w),

        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(AppIcons.dummyProfileCard),
        ),

        SizedBox(width: 12.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFont(
              'Katie Mizu',
              font: AppFontType.nunitoSans,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.chatTitleColor,
            ),
            SizedBox(height: 4.h),
            AppTextFont(
              'Online',
              font: AppFontType.nunitoSans,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.greenButtonColor,
            )
          ],
        ),

        Spacer(),

        InkWell(
          splashColor: Colors.transparent, // Hides the ripple
          highlightColor: Colors.transparent, // Hides the click highlight
          onTap: () {
            // Fav click event
            print('clicked');
          },
          child: AppIcons.getMenuIcon(context, size: 38),
        ),

        // Container(
        //   padding: EdgeInsets.all(10),
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade200,
        //     borderRadius: BorderRadius.circular(12.r),
        //   ),
        //   child: Icon(Icons.menu, color: Colors.deepPurple),
        // )
      ],
    ),
  );
}

Widget _messageBubble(BuildContext context, MessageModel message) {
  final theme = AppTheme.of(context);

  final radius = BorderRadius.only(
    topLeft: Radius.circular(18.r),
    topRight: Radius.circular(18.r),
    bottomLeft:
    message.isMe ? Radius.circular(18.r) : Radius.circular(4.r),
    bottomRight:
    message.isMe ? Radius.circular(4.r) : Radius.circular(18.r),
  );

  return Align(
    alignment:
    message.isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: message.type == MessageType.text
          ? EdgeInsets.all(14)
          : EdgeInsets.all(8),
      constraints: BoxConstraints(maxWidth: 280.w),
      decoration: BoxDecoration(
        color: message.isMe
            ? theme.primaryColor
            :  theme.segmentBGColor, borderRadius: radius,
      ),
      child: message.type == MessageType.text
          ? AppTextFont(
        message.message,
        font: AppFontType.nunitoSans,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color:  message.isMe ? theme.whiteColor : theme.iconTintHighlightColor,
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.asset(
          message.message,
          height: 180.h,
          width: 180.w,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget _messageInput(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30.r),
      ),
    ),
    child: Container(
      height: 55.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          // TextField
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type message here...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          // Send Icon inside field
          GestureDetector(
            onTap: () {
              // Send message logic
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: AppIcons.getSendMessageIcon(context),
            ),
          ),
        ],
      ),
    ),
  );
}
