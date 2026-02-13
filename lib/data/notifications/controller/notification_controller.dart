import 'package:get/get.dart';
import 'package:real_true_date/data/notifications/widget/notification_tile.dart';

class NotificationController extends GetxController {

  /// UI State
  final isFavorite = false.obs;

  final List<AppNotification> notifications = [
    AppNotification(
      id: "1",
      title: "Scott McTominay",
      subtitle: "want to Connect with you",
      time: "7 hours ago",
      imageUrl: "https://i.pravatar.cc/150?img=3",
      type: NotificationType.connectionRequest,
      isOnline: true,
    ),
    AppNotification(
      id: "2",
      title: "Upload Your Latest Video",
      subtitle: "to Continue Matching on TrueDate",
      time: "4 hours ago",
      imageUrl: "https://i.pravatar.cc/150?img=5",
      type: NotificationType.uploadVideo,
    ),
    AppNotification(
      id: "3",
      title: "Cylra Cantica Accepted",
      subtitle:
      "your match request. Start chatting now to get to know each other!",
      time: "4 hours ago",
      imageUrl: "https://i.pravatar.cc/150?img=6",
      type: NotificationType.matchAccepted,
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

  void toggleFavorite() {
    isFavorite.toggle();
  }
}
