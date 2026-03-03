import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/upload_picture_and_video/model/photo_list_model.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/custom_camera.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:real_true_date/helper/custom_dialog/authenticating_dialog.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class UploadPhotoController extends GetxController {
  /// CONTROLLERS
  final ImagePicker _picker = ImagePicker();

  /// UI State
  // final RxList<File> photos = <File>[].obs;
  final isLoading = false.obs;
  final photoListModel = <PhotoObject>[].obs;
  final errorMessage = ''.obs;

  int get maxPhotos => 2;
  bool get isButtonEnabled => photoListModel.length == maxPhotos;
  // bool get isButtonEnabled => photoListModel.isNotEmpty;
  final sharedPref = SharedPrefHelper();
  File? localImageFile;
  late var isVideoVerify = false;

  @override
  void onInit() {
    super.onInit();
    getImageListApiCall();
    getVideoFlag();
  }

  Future<void> captureImage() async {
    if (photoListModel.length >= maxPhotos) return;

    // Check camera permission
   /* PermissionStatus status = await Permission.camera.status;
    print("Camera permission status: $status");

    if (status.isDenied) {
      print('camer request');
      // Request permission
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      // Permission granted, capture image
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );

        if (image != null) {
          localImageFile = File(image.path);
          uploadImagesApiCall();
        }
      } catch (e) {
        errorMessage.value = "Failed to capture image: $e";
      }
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, show dialog
      _showPermissionDialog();
    } else {
      errorMessage.value = "Camera permission is required.";
    }*/


    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      // imageQuality: 50,
    );

    if (image != null) {

      int fSize = await image.length();
      print('Image size ${formatFileSize(fSize)}');

      // photos.add(File(image.path));
      localImageFile = File(image.path);
      uploadImagesApiCall();
    }


    /*final result = await Get.to(() => CustomCamera());

    if(result != null){
      print('result ${result.path}');
      localImageFile = File(result.path);
      uploadImagesApiCall();
    }*/
  }

  void removePhoto(int index) {
    // photoListModel.removeAt(index);
    final photoId = photoListModel[index].id ?? '';
    deleteSingleImageApiCall(photoId);
  }

  Future<void> getVideoFlag() async {
    isVideoVerify = await sharedPref.getVideoVerificationFlag();
  }

  Future<void> redirectVideoPage() async {
    // if(isVideoVerify){
    //   Get.back();
    // }
    // else{
    //   Get.toNamed(Routes.uploadVideoPage,);
    // }

    // Get.toNamed(Routes.selectDreamPartnerView,);
    Get.toNamed(Routes.confirmationInfo, arguments: {
        'initialIndex': 3,
      },
    );
  }

  //TODO: Upload images API Call
  Future<void> uploadImagesApiCall() async {
    AuthenticatingDialog.showLoader();

    final authToken = await sharedPref.getAuthToken;

    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken'
    };
    errorMessage.value = '';
    final response = await BaseApiService().formDataWithFile<CommonModel>(
      endpoint: Endpoints.uploadVerificationPhoto,
      file: localImageFile,
      fileField: 'photo',
      headers: header,
      fromJson: (json) => CommonModel.fromJson(json),
      isLoading: false
    );
    print('response ${response.tokenExpired}');

    AuthenticatingDialog.hideLoader();

    if (response.isSuccess && response.statusCode == 200) {
      getImageListApiCall();
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      if(response.tokenExpired == true){
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          uploadImagesApiCall();
        }
      } else {
        // Get.snackbar('Failed', response.message ?? 'Picture upload failed');
        // errorMessage.value = response.message ?? 'Picture upload failed';
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
        print(response.data?.data?.photos?.length);

        photoListModel.value = response.data?.data?.photos?.reversed.toList() ?? [];

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      print('response.tokenExpired ${response.tokenExpired}');
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
}
