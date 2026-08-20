import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/helper/custom_dialog/common_dialog_view.dart';

class FeedbackController extends GetxController {
  // --- Tab Selection State ---
  var selectedTabIndex = 0.obs;

  // --- Feedback Form Controllers ---
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController descriptionController;

  // --- Rating State (0.0 to 4.0) ---
  var ratingValue = 4.0.obs;

  // --- Loading State ---
  var isLoading = false.obs;

  final prefHelper = SharedPrefHelper();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // --- Action Methods ---

  void setRating(double value) {
    ratingValue.value = value;
  }

  /// Label helper based on current rating value index
  String get selectedRatingLabel {
    final labels = ['Worst', 'Not Good', 'Fine', 'Look Good', 'Very Good'];
    final index = ratingValue.value.round().clamp(0, 4);
    return labels[index];
  }

  /// Submit Feedback Form
  Future<void> submitFeedback() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final description = descriptionController.text.trim();

    // Basic Validation
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter your name',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return;
    }

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return;
    }

    if (description.isEmpty) {
      Get.snackbar('Error', 'Please enter a description',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return;
    }

    feedbackApiCall();
  }

  Future<void> feedbackApiCall() async {
    isLoading.value = true;
    final token = await prefHelper.getAuthToken;

    int rating = ratingValue.value.toInt() + 1;

    final params = {
      "name": nameController.text,
      "email": emailController.text,
      "rating": rating.toString(),
      "description": descriptionController.text,
    };

    print('update params $params');

    final response = await BaseApiService().postRawData<CommonModel>(
      endpoint: Endpoints.feedback,
      fields: params,
      headers: {
        'Authorization': 'Bearer $token'
      },
      fromJson: (json) => CommonModel.fromJson(json),
    );

    isLoading.value = false;
    if (response.isSuccess && response.statusCode == 200) {
      Get.dialog(
          CommonDialogView(
            title: 'Success',
            message: response.data?.message ?? 'Thank you! Your feedback has been submitted.',
            onConfirm: () {
              Get.back();
            },
              onCancel: () {
              print('back');
                Get.back();
                Future.delayed(const Duration(milliseconds: 500), () async {
                  Get.back();
                });
              }
          )
      );

      // Get.snackbar(
      //   'Success',
      //   response.data?.message ?? 'Thank you! Your feedback has been submitted.',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.green.withOpacity(0.8),
      //   colorText: Colors.white,
      // );
      //'Thank you! Your feedback has been submitted.'
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          feedbackApiCall();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit feedback. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    descriptionController.clear();
    ratingValue.value = 4.0;
  }
}