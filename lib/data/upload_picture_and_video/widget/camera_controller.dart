import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/upload_picture_and_video/model/photo_list_model.dart';
import 'package:video_player/video_player.dart';

class CameraViewController extends GetxController {
  late CameraController cameraController;

  /// UI State
  RxBool isInitialized = false.obs;
  RxBool isRecording = false.obs;

  RxInt countdown = 20.obs;
  // RxString overlayText = "".obs;
  Rx<File?> recordedFile = Rx<File?>(null);
  Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  RxBool isVideoPlaying = true.obs;
  final sharedPref = SharedPrefHelper();

  Timer? _timer;
  int currentCameraIndex = 0;

  List<CameraDescription> cameras = [];
  /// UI State
  final challengeListModel = <Challenge>[].obs;

  late List<String> randomTexts = [];
  late var sessionID = '';

  @override
  void onInit() {
    super.onInit();
    initCamera();
    getChallengesListApiCall();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        return;
      }
      currentCameraIndex = 0;

      cameraController = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: true,
      );

      await cameraController.initialize();

      isInitialized.value = true;
    } catch (e) {
      print("Camera error: $e");
    }
  }

  /// START RECORDING
  Future<void> startRecordingWithTimer(int seconds, List<String> texts) async {
    if (!cameraController.value.isInitialized || isRecording.value) return;

    await cameraController.startVideoRecording();
    isRecording.value = true;
    countdown.value = seconds;
    /// Countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      countdown.value--;

      if (countdown.value <= 0) {
        await stopRecording();
      }
    });
  }

  Future<void> stopRecording() async {
    // Stop timers
    _timer?.cancel();
    _timer = null;
    if (!isRecording.value || !cameraController.value.isRecordingVideo) {
      // Already stopped
      isRecording.value = false;
      countdown.value = 0;
      return;
    }

    final file = await cameraController.stopVideoRecording();

    // initialize video preview
    final vController = VideoPlayerController.file(File(file.path));

    await vController.initialize();   // ✅ initialize the local controller
    await vController.setLooping(false);

    videoController.value = vController; // assign first
    recordedFile.value = File(file.path); // then recorded file

    isVideoPlaying.value = false;
    isRecording.value = false;
    countdown.value = 0;
  }

  void toggleVideoPlayPause() {
    final v = videoController.value;
    if (v == null) return;

    if (v.value.isPlaying) {
      v.pause();
      isVideoPlaying.value = false;
    } else {
      v.play();
      isVideoPlaying.value = true;
    }
  }

  void retake() {
    recordedFile.value = null;
    videoController.value?.dispose();
    videoController.value = null;
    isVideoPlaying.value = true;
  }

  Future<void> switchCamera() async {
    if (cameras.isEmpty || cameras.length < 2) {
      debugPrint("Only one camera available");
      return;
    }

    currentCameraIndex = (currentCameraIndex + 1) % cameras.length;
    try {
      isInitialized.value = false;

      await cameraController.dispose();

      cameraController = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

      await cameraController.initialize();

      isInitialized.value = true;
    } catch (e) {
      debugPrint("Switch camera error: $e");
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    videoController.value?.dispose();
    super.onClose();
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
      sessionID = response.data?.data?.sessionId ?? '';
      challengeListModel.value = response.data?.data?.challenges ?? [];
      // Extract instructions into List<String>
      randomTexts = List<String>.from(
          challengeListModel.map((challenge) => capitalizeWords(challenge.instruction ?? ''))
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
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

  String capitalizeWords(String text) {
    return text
        .split(' ')                       // split into words
        .map((word) =>
    word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1)
        : ''
    ).join(' ');                       // join back into a sentence
  }
}