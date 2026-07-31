import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/select_dream_partner/model/dream_date_response_model.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/routes/routes.dart';

// CONTROLLER
class SelectDreamPartnerController extends GetxController {
  final isLoading = false.obs;


  final errorMessage = ''.obs;

  final sharedPref = SharedPrefHelper();

  final List<DreamDateItem> _selectedItems = [];

  // Make these reactive
  var catalogListModel = <DreamDateItem>[].obs;
  var selectedCatalogListModel = <DreamDateItem>[].obs;

  // Computed property for submit button
  bool get isSubmitButtonEnable => selectedCatalogListModel.isNotEmpty;

  void toggleSelection(DreamDateItem item) {
    // Check if we're trying to select and we've already reached the limit
    if (!selectedCatalogListModel.contains(item) && selectedCatalogListModel.length >= 2) {
      // Show a snackbar or toast to inform user about the limit
      Get.snackbar(
        'Limit Reached',
        'You can only select 2 dream partners',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Toggle selection
    if (selectedCatalogListModel.contains(item)) {
      selectedCatalogListModel.remove(item);
    } else {
      selectedCatalogListModel.add(item);
    }

    // Update both views
    update(); // This will update the main view
  }

  bool isSelected(DreamDateItem item) {
    return selectedCatalogListModel.contains(item);
  }


  @override
  void onInit() {
    super.onInit();
    getImageListApiCall();
  }

  /// TODO: Fetch images
  Future<void> getImageListApiCall() async {
    isLoading.value = true;
    final authToken = await sharedPref.getAuthToken;
    errorMessage.value = '';
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<DreamDateResponse>(
      endpoint: Endpoints.getDreamCatalog,
      headers: header,
      showLoader: false,
      fromJson: (json) => DreamDateResponse.fromJson(json),
    );

    isLoading.value = false;

    if (response.isSuccess &&
response.statusCode == 200 &&
        response.data?.success == true) {
      catalogListModel.value =
          response.data?.data.catalog.reversed.toList() ?? [];
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getImageListApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
    update();
  }

  Future<void> submitSelectedCatalogs() async {
    final controller = Get.find<SelectDreamPartnerController>();

    // Check if there is at least one selection
    if (controller.selectedCatalogListModel.isEmpty) {
      Get.snackbar(
        'No Selection',
        'Please select at least one item before submitting.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    // Prepare catalog_ids array
    final catalogIds = controller.selectedCatalogListModel
        .map((item) => item.id)
        .toList();

    final payload = {
      "catalog_ids": catalogIds,
    };

    print('Payload: $payload');
    final authToken = await sharedPref.getAuthToken;

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };
    // Make API call
    final response = await BaseApiService().postRawData<DreamDateResponse>(
      endpoint: Endpoints.saveDreamDateSelect,
      headers: header,
      fields: payload,
      fromJson: (json) => DreamDateResponse.fromJson(json),
    );

    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      // Success feedback
      // Get.snackbar(
      //   'Success',
      //   'Selection submitted successfully!',
      //   snackPosition: SnackPosition.BOTTOM,
      // );

      // Optional: clear selection after submit
      controller.selectedCatalogListModel.clear();
      // controller.isSubmitButtonEnable.value = false;
      controller.update();
      // Get.offAll(() => BottomNavWrapper());

      Get.toNamed(Routes.confirmationInfo, arguments: {
        'initialIndex': 1,
        },
      );

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      Get.snackbar('Failed', response.message ?? 'Submission failed');
    }
  }
}