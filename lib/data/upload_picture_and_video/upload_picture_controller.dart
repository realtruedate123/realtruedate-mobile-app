import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/upload_picture_and_video/custom_camera/camera_screen.dart';
import 'package:real_true_date/data/upload_picture_and_video/model/photo_list_model.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/helper/custom_dialog/authenticating_dialog.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';

class UploadPhotoController extends GetxController {
  /// CONTROLLERS
  final ImagePicker _picker = ImagePicker();

  /// UI State
  final isLoading = false.obs;
  final photoListModel = <PhotoObject>[].obs;
  final errorMessage = ''.obs;

  int get maxPhotos => 2;
  bool get isButtonEnabled => photoListModel.length == maxPhotos;
  final sharedPref = SharedPrefHelper();
  File? localImageFile;
  late var isVideoVerify = false;
  String isComing = '';
  String selectedPhotoID = '';

  @override
  void onInit() {
    super.onInit();

    final String args = Get.arguments ?? '';
    isComing = args;

    getImageListApiCall();
    getVideoFlag();
  }

  Future<void> captureImage() async {
    if (photoListModel.length >= maxPhotos) return;

    // Check camera permission
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      // imageQuality: 50,
    );

    if (image != null) {
      int fSize = await image.length();
      // photos.add(File(image.path));
      localImageFile = File(image.path);
      uploadImagesApiCall();
    }
  }

  void openCameraAndUpload() async {
    // 1. Open Camera screen & wait for confirmed preview result
    localImageFile = await Get.to<File?>(() => const CameraScreen());

    // 2. Upload to server only if user tapped "Use Photo"
    if (localImageFile != null) {
      // Trigger your upload API call
      uploadImagesApiCall();
    }
  }

  void removePhoto(int index) {
    // photoListModel.removeAt(index);
    final photoId = photoListModel[index].id ?? '';
    deleteSingleImageApiCall(photoId);
  }

  void changePhoto(int index){
    final photoId = photoListModel[index].id ?? '';
    selectedPhotoID = photoId;
    openCameraAndUpload();
  }

  Future<void> getVideoFlag() async {
    isVideoVerify = await sharedPref.getVideoVerificationFlag();
  }

  Future<void> redirectVideoPage() async {
    Get.toNamed(Routes.confirmationInfo, arguments: {
        'initialIndex': 3,
      },
    );
  }

  //TODO: Upload images API Call
  Future<void> uploadImagesApiCall() async {
    AuthenticatingDialog.showLoader();

    final authToken = await sharedPref.getAuthToken;

    var url = Endpoints.uploadVerificationPhoto;
    var method = 'POST';
    if(isComing == 'update_video'){
      method = 'PUT';
      url = '${Endpoints.getPhotos}/$selectedPhotoID/update';
    }
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken'
    };
    errorMessage.value = '';
    final response = await BaseApiService().formDataWithFile<CommonModel>(
      method: method,
      endpoint: url,
      file: localImageFile,
      fileField: 'photo',
      headers: header,
      fromJson: (json) => CommonModel.fromJson(json),
      isLoading: false
    );
    AuthenticatingDialog.hideLoader();

    if (response.isSuccess && response.statusCode == 200) {
      getImageListApiCall();
      getUserDataApiCall();
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if(response.tokenExpired == true){
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          uploadImagesApiCall();
        }
      } else {
        AuthenticatingDialog.showError(response.message ?? 'Picture upload failed');
      }
    }
  }

  //TODO: Get images list API Call
  Future<void> getImageListApiCall() async {

    isLoading.value = true;
    final authToken = await sharedPref.getAuthToken;
    errorMessage.value = '';
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken'
    };

    final response = await BaseApiService().getMethod<PhotoListModel>(
      endpoint: Endpoints.getPhotos,
      headers: header,
      showLoader: false,
      fromJson: (json) => PhotoListModel.fromJson(json),
    );

    isLoading.value = false; // hide shimmer
    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
        photoListModel.value = response.data?.data?.photos?.reversed.toList() ?? [];
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if(response.tokenExpired == true){
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getImageListApiCall();
        }
      } else{
        Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
    update();
  }

  //TODO: Delete single image API Call
  Future<void> deleteSingleImageApiCall(String photoId) async {
    final authToken = await sharedPref.getAuthToken;
    final pid = photoId;
    selectedPhotoID = photoId;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken'
    };

    final response = await BaseApiService().sendRequest<CommonModel>(
      endpoint: '${Endpoints.deleteSinglePhoto}/$photoId/delete',
      headers: header,
      method: HttpMethod.delete,
      fromJson: (json) => CommonModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200) {
      getImageListApiCall();
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if(response.tokenExpired == true){
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          deleteSingleImageApiCall(pid);
        }
      }else {
        Get.snackbar('Failed', response.message ?? 'Picture upload failed');
      }
    }
  }

  Future<void> getUserDataApiCall() async {
    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<LoginModel>(
      endpoint: Endpoints.meApi,
      headers: header,
      showLoader: false,
      fromJson: (json) => LoginModel.fromJson(json),
    );
    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      await Future.wait([
        sharedPref.saveIsLoggedIn(true),
        sharedPref.savePersonList(response.data!.data!),
        sharedPref.saveUserId(response.data!.data?.user?.id ?? '')
      ]);
      AppState.instance.loginUserID = response.data!.data?.user?.id ?? '';
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getUserDataApiCall();
        }
      } else {
        // Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
  }
}
