import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

enum MessageType { text, image }

class MessageModel {
  final String message;
  final bool isMe;
  final MessageType type;

  MessageModel({
    required this.message,
    required this.isMe,
    this.type = MessageType.text,
  });
}

class ChatController extends GetxController {

  /// UI State
  final isLoading = false.obs;

  List<MessageModel> messages = [
    MessageModel(
      message: "Hi, how are you? and well, happy belated birthday!",
      isMe: true,
    ),
    MessageModel(
      message: "Nice to know!",
      isMe: true,
    ),
    MessageModel(
      message: "Wow thank you!",
      isMe: false,
    ),
    MessageModel(
      message: "You should come to my house lol!",
      isMe: false,
    ),
    MessageModel(
      message: AppIcons.dummyProfileCard,
      isMe: false,
      type: MessageType.image,
    ),
  ];


  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();
  }
}
