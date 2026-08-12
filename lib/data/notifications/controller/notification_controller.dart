import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/notifications/model/notification_list_model.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/routes/routes.dart';

class NotificationController extends GetxController {

  /// UI State
  final isFavorite = false.obs;
  final sharedPref = SharedPrefHelper();

  var notifications = <NotificationObject>[].obs;

  int page = 1;
  final int pageLimit = 20;

  bool hasMore = true;
  bool isLoading = false;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getNotificationListApiCall();

    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _onScroll() async {
    if (!hasMore || isLoading) return;

    isLoading = true;

    page++;
    await getNotificationListApiCall();

    isLoading = false;
  }

  Future<void> refreshNotifications() async {
    page = 1;
    hasMore = true;
    notifications.clear();

    await getNotificationListApiCall();
  }

  //TODO: Get Notification List API Call
  Future<void> getNotificationListApiCall() async {

    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<NotificationListModel>(
      endpoint: '${Endpoints.getNotifications}?page=$page&page_size=$pageLimit',
      headers: header,
      fromJson: (json) => NotificationListModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
      // notifications.value = response.data?.data?.notifications ?? [];
      final newNotifications = response.data?.data?.notifications ?? [];

      if (page == 1) {
        notifications.value = newNotifications;
      } else {
        notifications.addAll(newNotifications);
      }

      // hasMore = newNotifications.length == pageLimit;
      // Use API response
      hasMore = response.data?.data?.hasMore ?? false;

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getNotificationListApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
    }
    update();
  }

  Future<void> acceptOrDeclineApiCall(String type, String conversationId) async {
    final token = await sharedPref.getAuthToken;

    final params = {
      "action": type,
    };

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $token',
    };

    final response = await BaseApiService().postRawData<CommonModel>(
      endpoint: '${Endpoints.notificationsAcceptOrDecline}/$conversationId/respond',
      fields: params,
      headers: header,
      fromJson: (json) => CommonModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
      print("Response data: ${response.data?.message}");
      if(type.toLowerCase() == 'accept'){
        Get.toNamed(Routes.chatView, arguments: {
          'conversation_id': conversationId
        });
      }
      else{
        Get.snackbar('Success', response.message ?? 'Something want wrong',
            colorText: Colors.white,
            backgroundColor: Colors.green
        );
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          acceptOrDeclineApiCall(type, conversationId);
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something want wrong',
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      }
    }
  }
}
