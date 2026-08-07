import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/data/message_tab/controller/chat_controller.dart';
import 'package:real_true_date/data/message_tab/model/message_model.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/routes/routes.dart';

class ChatView extends StatelessWidget {
  final controller = Get.put(ChatController());
  final TextEditingController textController = TextEditingController();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _chatHeader(context, controller),

            // Optional Status Banner
            Obx(() {
              if (controller.bannerText.value.isEmpty) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                color: Colors.amber.shade100,
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                child: Text(
                  controller.bannerText.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 13.sp),
                ),
              );
            }),

            SizedBox(height: 10.h),
            const Text(
              "Today",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 10.h),

            /// Messages List
            Expanded(
              child: Container(
                color: theme.offWhiteBGColor,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.messages.isEmpty) {
                    return const Center(
                      child: Text("No messages found"),
                    );
                  }

                  return  ListView.builder(
                    reverse: true, // Show newest messages at bottom
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      return _messageBubble(context, controller.messages[index], controller);
                    },
                  );
                }),
              ),
            ),

            /// Input Field Dynamic Handling
            _messageInput(context, controller, textController),
          ],
        ),
      ),
    );
  }
}

Widget _chatHeader(BuildContext context, ChatController controller) {
  final theme = AppTheme.of(context);

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
    ),
    child: Obx(() {
      final isTyping = controller.isOtherUserTyping.value;
      final status = controller.otherUserStatus.value;
      final data = controller.conversationData.value;

      return Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => Get.back(),
              child: AppIcons.getLeftArrow(context, size: 30),
            ),
            SizedBox(width: 10.w),
            // CircleAvatar(
            //   radius: 25,
            //   backgroundImage: AssetImage(AppIcons.dummyProfileCard),
            // ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Get.toNamed(Routes.chatProfileDetailsView, arguments: {
                  'id': data.recipient?.id ?? '',
                  'data': data.recipient
                });
              },
              child: AppCachedImage(
                imageUrl: data.recipient?.photoUrl ?? '',
                height: 45,
                width: 45,
                fit: BoxFit.cover,
                  borderRadius: 45
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFont(
                  data.recipient?.fullName?.capitalize ?? '',
                  font: AppFontType.nunitoSans,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.chatTitleColor,
                ),
                SizedBox(height: 4.h),
                AppTextFont(
                  isTyping ? 'typing...' : (status.isEmpty ? 'Offline' : status.capitalizeFirst!),
                  font: AppFontType.nunitoSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: status == 'online' ? theme.greenButtonColor : Colors.grey,
                ),
              ],
            ),
            /*const Spacer(),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                  Get.toNamed(Routes.chatProfileDetailsView, arguments: {
                    'id': data.recipient?.id ?? '',
                    'data': data.recipient
                  });
              },
              child: AppIcons.getMenuIcon(context, size: 38),
            ),*/
          ],
        );
    })
  );
}

Widget _messageBubble(BuildContext context, MessageObject message, ChatController controller) {
  final theme = AppTheme.of(context);
  final isMe = message.senderId == controller.currentUserId;
  // print('isMe $isMe');
  // print('senderId ${message.senderId}');
  // print('currentUserId ${controller.currentUserId}');

  final radius = BorderRadius.only(
    topLeft: Radius.circular(18.r),
    topRight: Radius.circular(18.r),
    // bottomLeft: message.isMe ? Radius.circular(18.r) : Radius.circular(4.r),
    // bottomRight: message.isMe ? Radius.circular(4.r) : Radius.circular(18.r),
    bottomLeft: isMe ? Radius.circular(18.r) : Radius.circular(4.r),
    bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(18.r),
  );

  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: message.messageType.toString() == 'text' ? const EdgeInsets.all(14) : const EdgeInsets.all(8),
      constraints: BoxConstraints(maxWidth: 280.w),
      decoration: BoxDecoration(
        color: isMe ? theme.primaryColor : theme.segmentBGColor,
        borderRadius: radius,
      ),
      child: message.messageType.toString() == 'text'
          ? AppTextFont(
        message.content ?? '',
        font: AppFontType.nunitoSans,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isMe ? theme.whiteColor : theme.iconTintHighlightColor,
      )
          : ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          message.imageUrl ?? '',
          height: 180.h,
          width: 180.w,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget _messageInput(
    BuildContext context,
    ChatController controller,
    TextEditingController textController,
    ) {
  return Obx(() {
    final enabled = controller.isInputEnabled.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Container(
        height: 55.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey.shade200 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                enabled: enabled,
                onChanged: (val) => controller.sendTypingIndicator(val.isNotEmpty),
                decoration: InputDecoration(
                  hintText: enabled ? "Type message here..." : controller.bannerText.value,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: enabled
                  ? () {
                controller.sendTextMessage(textController.text);
                textController.clear();
              }
                  : null,
              child: Opacity(
                opacity: enabled ? 1.0 : 0.4,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: AppIcons.getSendMessageIcon(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}





/*import 'package:flutter/cupertino.dart';
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
*/