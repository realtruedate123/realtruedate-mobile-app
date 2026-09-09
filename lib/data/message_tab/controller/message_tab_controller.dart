import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/message_tab/model/chat_model.dart';

class MessageTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;

  final sharedPref = SharedPrefHelper();

  var userChatList = <ConversationModel>[].obs;
  var searchChatList = <ConversationModel>[].obs;

  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUserChatListApiCall();
  }

  //TODO: Get User chat List API Call
  Future<void> getUserChatListApiCall() async {

    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<ChatListModel>(
      endpoint: Endpoints.notificationsAcceptOrDecline,
      headers: header,
      fromJson: (json) => ChatListModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
      userChatList.value = response.data?.data?.conversations ?? [];
      searchChatList.assignAll(response.data?.data?.conversations ?? []);
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getUserChatListApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
    }
    update();
  }

  void searchChats(String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      userChatList.assignAll(searchChatList);
      return;
    }

    final filtered = searchChatList.where((item) {
      final name = item.recipient?.fullName?.trim().toLowerCase() ?? '';
      return name.contains(searchQuery);
    }).toList();

    userChatList.assignAll(filtered);
  }
}
