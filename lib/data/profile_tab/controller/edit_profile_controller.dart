import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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


  final nameError = RxnString();
  final zipcodeError = RxnString();
  final birthDateError = RxnString();
  final farWilingToDriveError = RxnString();

  // FIX: Change these from Rx to Rxn
  final dob = Rxn<DateTime>();  // Instead of Rx<DateTime?>()
  final lookingGender = RxnString();  // Instead of RxString()

  RxString selectedGender = 'Male'.obs;


  @override
  void onInit() {
    super.onInit();
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

  @override
  void onClose() {
    super.onClose();
  }
}