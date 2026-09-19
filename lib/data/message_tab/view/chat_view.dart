import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:real_true_date/core/themes/app_icons.dart';
import 'package:real_true_date/core/themes/app_theme.dart';
import 'package:real_true_date/core/utils/DateHelper.dart';
import 'package:real_true_date/data/message_tab/controller/chat_controller.dart';
import 'package:real_true_date/data/message_tab/model/message_model.dart';
import 'package:real_true_date/data/message_tab/widget/report_user_bottom_sheet.dart';
import 'package:real_true_date/helper/app_cached_image.dart';
import 'package:real_true_date/helper/app_text_font.dart';
import 'package:real_true_date/helper/custom_dialog/confirmation_dialog.dart';
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
                  return  ListView.builder(
                    reverse: true, // Show newest messages at bottom
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];

                      String? nextDate;
                      if (index < controller.messages.length - 1) {
                        nextDate = controller.messages[index + 1].createdAt;
                      }
                      final showDateSeparator = nextDate == null || !isSameDay(message.createdAt, nextDate);

                      return Column(
                        children: [
                          if (showDateSeparator)
                            _chatDateSeparator(message.createdAt, context),

                          _messageBubble(context, controller.messages[index], controller),
                        ],
                      );
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

/*Widget _chatHeader1(BuildContext context, ChatController controller) {
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
          ],
        );
    })
  );
}*/

Widget _chatHeader(BuildContext context, ChatController controller) {
  final theme = AppTheme.of(context);
  final blockUserText = controller.isBlocked.value ? 'Unblock' : 'Block';

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
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Get.toNamed(Routes.chatProfileDetailsView, arguments: {
                'id': data.recipient?.id ?? '',
                'data': data.recipient
              });
            },
            child:Stack(
              clipBehavior: Clip.none,
              children:[
                AppCachedImage(
                  imageUrl: data.recipient?.photoUrl ?? '',
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                  borderRadius: 45,
                ),
                if(controller.isBlocked.value)...[
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.block,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]
              ]
            ),
          ),
          SizedBox(width: 12.w),
          Expanded( // 👈 Expanded keeps user details flexible and pushes menu to the right
            child: Column(
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
                  isTyping
                      ? 'typing...'
                      : (status.isEmpty ? 'Offline' : status.capitalizeFirst!),
                  font: AppFontType.nunitoSans,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: status == 'online'
                      ? theme.greenButtonColor
                      : Colors.grey,
                ),
              ],
            ),
          ),

          // 👈 Right More Options Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              switch (value) {
                case 'view_profile':
                  Get.toNamed(Routes.chatProfileDetailsView, arguments: {
                    'id': data.recipient?.id ?? '',
                    'data': data.recipient
                  });
                  break;
                case 'report': // 👈 Report user option handler
                // TODO: Add report user handler
                  showDialog(
                    context: context,
                    barrierColor: Colors.black12.withAlpha(204),
                    builder: (context) => ConfirmationDialog(
                      title: 'Report User',
                      message: 'Are you sure you want to report this user for inappropriate behavior?',
                      onConfirm: () {
                        Get.back();
                        ReportUserBottomSheet.show(
                          context: context,
                          userId: data.recipient?.id ?? '',
                          onReportSubmit: (selectedReason, customText) {
                            // Receive values in parent widget or controller
                            print('Selected Reason: $selectedReason');
                            print('Custom Text: $customText');

                            // Call your API or controller method here
                            controller.reportUserApiCall(data.recipient?.id ?? '', selectedReason, customText ?? '');
                          },
                        );

                      },
                      confirmText: 'Report',
                      cancelText: 'Cancel',
                    ),
                  );
                  break;
                case 'block':
                // TODO: Add block user handler
                  showDialog(
                    context: context,
                    barrierColor: Colors.black12.withAlpha(204),
                    builder: (context) => ConfirmationDialog(
                      title: '$blockUserText User',
                      message: 'Are you sure you want to ${blockUserText.toLowerCase()}. this user?',
                      onConfirm: () {
                        Get.back();
                        controller.blockUser(data.recipient?.id ?? '');
                      },
                      confirmText: blockUserText,
                      cancelText: 'Cancel',
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'view_profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20, color: Colors.black87),
                    SizedBox(width: 10),
                    Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.outlined_flag, size: 20, color: Colors.orange),
                    SizedBox(width: 10),
                    Text('Report User', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, size: 20, color: Colors.red),
                    SizedBox(width: 10),
                    Text('$blockUserText User', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}

Widget _messageBubble(BuildContext context, MessageObject message, ChatController controller) {
  final theme = AppTheme.of(context);
  final isMe = message.senderId == controller.currentUserId;

  final radius = BorderRadius.only(
    topLeft: Radius.circular(18.r),
    topRight: Radius.circular(18.r),
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

Widget _chatDateSeparator(String? dateString, BuildContext context) {
  final theme = AppTheme.of(context);

  if (dateString == null || dateString.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  DateTime date;

  try {
    date = DateTime.parse(dateString).toLocal();
  } catch (_) {
    return const SizedBox.shrink();
  }

  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final messageDate = DateTime(
    date.year,
    date.month,
    date.day,
  );

  final difference = today.difference(messageDate).inDays;

  String label;

  if (difference == 0) {
    label = 'Today';
  } else if (difference == 1) {
    label = 'Yesterday';
  } else {
    label = DateFormat('dd MMM yyyy').format(date);
  }

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: theme.lightPurpleColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}