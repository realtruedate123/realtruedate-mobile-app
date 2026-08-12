import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';

class EditProfileController extends GetxController {
  var isEditable = false.obs;

  // toggle editable
  void toggleEditable() => isEditable.value = !isEditable.value;

  // Add observable for avatar image
  var avatarPath = ''.obs; // file path or network fallback

  final ImagePicker _picker = ImagePicker();

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// CONTROLLERS
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pinCodeCtrl = TextEditingController();
  final birthDateCtrl = TextEditingController();
  final farWilingToDriveCtrl = TextEditingController();
  final bioController = TextEditingController();


  final nameError = RxnString();
  final zipcodeError = RxnString();
  final birthDateError = RxnString();
  final farWilingToDriveError = RxnString();

  // FIX: Change these from Rx to Rxn
  final dob = Rxn<DateTime>();  // Instead of Rx<DateTime?>()
  final lookingGender = RxnString();  // Instead of RxString()

  RxString selectedGender = 'Male'.obs;
  final prefHelper = SharedPrefHelper();
  Rx<File?> localImageFile = Rx<File?>(null); // from camera/gallery
  List<String> selectedInterests = [];
  final interests = <String>[].obs;
  var profileUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // getUserData();
    getUserDataApiCall(false);
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) avatarPath.value = pickedFile.path;
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) avatarPath.value = pickedFile.path;
  }

  /// Show bottom sheet to choose camera or gallery
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () async {
                Navigator.pop(context);
                await pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Gallery"),
              onTap: () async {
                Navigator.pop(context);
                await pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void setDob(DateTime value) {
    dob.value = value;
    _validateForm();
  }

  void setLookingGender(String value) {
    lookingGender.value = value;
    _validateForm();
  }

  void setGender(String value) {
    selectedGender.value = value;
  }

  void _validateForm() {
    pinCodeCtrl.text.trim().isNotEmpty &&
        dob.value != null;
  }

  /// Get saved local user data
  void getUserData(DataModel userProfile) async {
    try {
      // final data = await prefHelper.getPersonList();
      // final userProfile = data ?? DataModel();

      print('userProfile ${userProfile.user?.profileImage ?? ''}');
      profileUrl.value = userProfile.user?.profileImage ?? '';
      nameCtrl.text = userProfile.user?.fullName ?? '';
      emailCtrl.text = userProfile.user?.email ?? '';

      DateTime date = DateTime.parse(userProfile.user?.dateOfBirth ?? '');
      dob.value = date;

      interests.value = userProfile.profile?.interests ?? [];
      bioController.text = userProfile.user?.bio ?? '';

      selectedInterests =  interests;
      print('controller.interests ${interests.toList()}');

      update();

    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile data
  Future<void> updateProfileApiCall() async {
    final token = await prefHelper.getAuthToken;
    print('selectedInterests $selectedInterests');

    final dateString = DateFormat('yyyy-MM-dd').format(dob.value!);

    final params = {
      "full_name": nameCtrl.text,
      "date_of_birth": dateString,
      "gender": selectedGender.value.toString()[0],
      "bio": bioController.text,
      "interests": jsonEncode(selectedInterests),
    };

    print('update params $params');

    final response = await BaseApiService().formDataWithFile<LoginModel>(
      endpoint: Endpoints.updateUserProfile,
      method: 'PUT',
      fields: params,
      // file: localImageFile.value,
      filePath: avatarPath.value,
      fileField: 'profile_image',
      headers: {
        'Authorization': 'Bearer $token'
      },
      fromJson: (json) => LoginModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
        getUserDataApiCall(true);
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          updateProfileApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Profile update failed');
      }
    }
  }

  Future<void> getUserDataApiCall(bool isUpdate) async {
    final authToken = await prefHelper.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<LoginModel>(
      endpoint: Endpoints.meApi,
      headers: header,
      fromJson: (json) => LoginModel.fromJson(json),
    );

    print('Get me api $header');

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('get me ${response.data?.data?.user?.id}');

      print('response ${response.message}');
      print('profile dob ${response.data?.data?.user?.dateOfBirth}');
      print('profile url ${response.data?.data?.user?.profileImage}');
      print('profile bio ${response.data?.data?.user?.bio}');
      print('profile interests ${response.data?.data?.profile?.interests}');

      await Future.wait([
        prefHelper.savePersonList(response.data!.data!),
      ]);

      if(isUpdate){
        Future.delayed(const Duration(seconds: 1), () async {
          Get.back(result: true);
        });
      }else{
        getUserData(response.data?.data ?? DataModel());
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getUserDataApiCall(isUpdate);
        }
      } else {
        // Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}