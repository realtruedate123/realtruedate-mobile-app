import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:image_picker/image_picker.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/utils/DateHelper.dart';
import 'package:real_true_date/data/upload_picture_and_video/model/photo_list_model.dart';
import 'package:real_true_date/data/upload_picture_and_video/widget/camera_screen.dart';
import 'package:real_true_date/helper/custom_dialog/authenticating_dialog.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class UploadVideoController extends GetxController {
  /// Video file
  final Rxn<File?> videoFile = Rxn<File?>(null);
  // File? videoFile;

  /// Recording state
  final RxBool isRecording = false.obs;
  final RxString secondsLeft = '0'.obs;
  final RxBool isUploading = false.obs;
  final RxString fileName = 'Introduction Video.mp4'.obs;
  final RxString fileSize = '0.0'.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final RxBool showText = false.obs;
  final RxString currentText = "".obs;
  late String sessionID = '';

  /// Timer
  final RxInt elapsedSeconds = 0.obs;
  static const int maxSeconds = 19;

  /// Upload simulation
  final RxDouble uploadProgress = 0.0.obs;
  final isVideoUpload = false.obs;
  final isMessage = false.obs;

  /// Video player
  VideoPlayerController? videoPlayer;

  Timer? _timer;
  final cancelToken = CancelToken();
  final sharedPref = SharedPrefHelper();

  /// formatted mm:ss
  String get formattedTime {
    final m = (elapsedSeconds.value ~/ 60).toString().padLeft(2, '0');
    final s = (elapsedSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void onInit() {
    super.onInit();
    getChallengesListApiCall();
  }


  /// 🎥 Record video (camera only)
  Future<void> recordVideo() async {
    print('click video record');
    final picker = ImagePicker();

    elapsedSeconds.value = 0;
    isRecording.value = true;
    _startTimer();

    final XFile? result = await picker.pickVideo(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxDuration: const Duration(seconds: maxSeconds),
    );

    _stopRecording();

    if (result != null) {
      // sessionID = result["session_id"];
      videoFile.value = File(result.path);
      await _initPlayer(videoFile.value!);

      String fName = path.basename(result.path);
      int fSize = await result.length();

      print('Name: $fName');
      print('Size: ${formatFileSize(fSize)}');
      fileName.value = shortenFileName(fName);
      fileSize.value = formatFileSize(fSize);
      videoUploadApiCall(sessionID);
    }
  }

  /*
  Future<void> cameraVideo() async {
    // final result = await Get.to<File>(() => CameraScreen());

    final result = await Get.to(() => CameraScreen());

    if(result != null){
      print(result);
      File file = result["file"];
      sessionID = result["session_id"];

      videoFile.value = File(file.path);
      await _initPlayer(videoFile.value!);

      String fName = path.basename(file.path);
      int fSize = await file.length();

      print('Name: $fName');
      print('Size: ${formatFileSize(fSize)}');
      fileName.value = shortenFileName(fName);
      fileSize.value = formatFileSize(fSize);
      videoUploadApiCall(sessionID);
    }
  }
*/
    /// After recording success
  void onVideoCaptured(File file) {
    videoFile.value = file;
  }


  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;

      final remaining = maxSeconds - elapsedSeconds.value;

      /// 🔔 vibrate last 5 seconds
      if (remaining <= 5 && remaining > 0) {
        HapticFeedback.mediumImpact();
      }

      if (elapsedSeconds.value >= maxSeconds) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    isRecording.value = false;
  }

  /// 🎞 Init video player
  Future<void> _initPlayer(File file) async {
    videoPlayer?.dispose();
    videoPlayer = VideoPlayerController.file(file);
    await videoPlayer!.initialize();
    videoPlayer!.setLooping(false);
    update();
  }

  /// ❌ Remove / re-record
  void removeVideo() {
    videoPlayer?.dispose();
    videoPlayer = null;
    videoFile.value = null;
    uploadProgress.value = 0;
    elapsedSeconds.value = 0;
    isUploading.value = false;
    errorMessage.value = '';
    // cancelToken.cancel("User cancelled upload");
  }

  @override
  void onClose() {
    videoPlayer?.dispose();
    _timer?.cancel();
    super.onClose();
  }

  //TODO: Video upload API Call
  Future<void> videoUploadApiCall(String sessionID) async {

    final authToken = await sharedPref.getAuthToken;

    // final header = {
    //   'Content-Type': 'multipart/form-data',
    //   "Authorization": 'Bearer $authToken'
    // };

    print('Bearer $authToken');
    print('video file url ${videoFile.value!}');
    errorMessage.value = '';
    isVideoUpload.value = false;
    isMessage.value = false;

    uploadFileWithProgress(
        baseUrl: 'http://airealconnect.com/api/v1/auth/',
        endpoint: Endpoints.uploadVerificationVideo,
        file: videoFile.value!,
        token: authToken,
        onProgress: (double progress, Duration remaining) {
          print('progress $progress');
          print('remaining $remaining');
          isUploading.value = true;
          uploadProgress.value = progress;
          // secondsLeft.value = remaining.inSeconds.toString();
          secondsLeft.value = formatTime(remaining);//remaining.inSeconds;
          if (uploadProgress.value == 1.0) {
            AuthenticatingDialog.showLoader();
          }
        });
  }

  Future<Response> uploadFileWithProgress({
    required String baseUrl,
    required String endpoint,
    required File file,
    required String token,
    String fileField = "video",
    CancelToken? cancelToken,
    required void Function(double progress, Duration remaining) onProgress,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Authorization": "Bearer $token",
          // "Accept": "application/json",
          "Content-Type": "multipart/form-data"
        },
        validateStatus: (status) => true,
      ),
    );
    
    final formData = FormData.fromMap({
      fileField: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'session_id': sessionID
    });

    final stopwatch = Stopwatch()..start();

    try {
      final response = await dio.post(
        endpoint,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total <= 0) return;

          final progress = sent / total;

          if (stopwatch.elapsedMilliseconds > 0) {
            final speed = sent / stopwatch.elapsedMilliseconds; // bytes/ms
            final remainingBytes = total - sent;
            final remainingMs =
            speed > 0 ? (remainingBytes / speed).round() : 0;

            onProgress(
              progress.clamp(0.0, 1.0),
              Duration(milliseconds: remainingMs),
            );
          }
        },
      );
      print('response ${response.data.toString()}');
      print('status ${response.statusCode}');
      print('status ${response.data['message']}');
      isVideoUpload.value = true;
      AuthenticatingDialog.hideLoader();

      if (response.data['success'] == true && response.statusCode! >= 200 && response.statusCode! < 300) {
        print('video success ${response.data.toString()}');
        // errorMessage.value = response.data['message'];
        isMessage.value = true;
        AuthenticatingDialog.showError(response.data['message']);
        return response;
      } else if (response.data['token_expired'] == true) {
        print('token_expired');
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          videoUploadApiCall(sessionID);
        }
        throw Exception(response.data.toString());
      }
      else {
        print(response.data['message']);
        // errorMessage.value = response.data['message'];
        isMessage.value = false;
        AuthenticatingDialog.showError(response.data['message']);
        throw Exception(response.data.toString());
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw Exception("Upload cancelled");
      }
      throw Exception(e.response?.data ?? e.message);
    }
  }

  //TODO: Get challenges list API Call
  Future<void> getChallengesListApiCall() async {

    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken'
    };

    final response = await BaseApiService().getMethod<ChallengesListModel>(
      endpoint: Endpoints.challenges,
      headers: header,
      showLoader: false,
      fromJson: (json) => ChallengesListModel.fromJson(json),
    );

    if (response.isSuccess && response.statusCode == 200 && response.data?.success == true) {
      print('get challenge ${response.data?.data?.challenges?.length}');

      sessionID = response.data?.data?.sessionId ?? '';
      // challengeListModel.value = response.data?.data?.challenges ?? [];

      // Extract instructions into List<String>
      // randomTexts = List<String>.from(
      //     challengeListModel.map((challenge) => capitalizeWords(challenge.instruction ?? ''))
      // );


    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      print('response.tokenExpired ${response.tokenExpired}');
      if(response.tokenExpired == true){
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getChallengesListApiCall();
        }
      } else{
        // Get.snackbar('Failed', response.message ?? 'failed');
      }
    }
  }
}
