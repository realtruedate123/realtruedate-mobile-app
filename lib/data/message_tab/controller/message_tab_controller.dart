import 'package:get/get.dart';
import 'package:real_true_date/core/themes/app_icons.dart';

class ChatModel {
  final String name;
  final String message;
  final String image;
  final int unreadCount;
  final bool isOnline;

  ChatModel({
    required this.name,
    required this.message,
    required this.image,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}


class MessageTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;

  final List<ChatModel> chatList = [
    ChatModel(
      name: "Katie Mizu",
      message: "Cool, Will let you know ASAP!",
      image: AppIcons.dummyProfileCard,
      unreadCount: 2,
      isOnline: true,
    ),
    ChatModel(
      name: "Jimoni Wong",
      message: "Hey, where are you?",
      image: AppIcons.dummyProfileCard,
    ),
    ChatModel(
      name: "Katie Mizu",
      message: "Cool, Will let you know ASAP!",
      image: AppIcons.dummyProfileCard,
      unreadCount: 1,
      isOnline: true,
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
