import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CustomCameraController extends GetxController {
  late CameraController cameraController;

  /// UI State
  RxBool isInitialized = false.obs;
  RxBool isRecording = false.obs;

  final sharedPref = SharedPrefHelper();

  int currentCameraIndex = 0;

  List<CameraDescription> cameras = [];
  Rx<XFile?> capturedImage = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        print("No cameras found");
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

  /// TAKE PHOTO ONLY (does NOT affect video logic)
  Future<void> takePhoto() async {
    if (!cameraController.value.isInitialized ||
        cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile photo = await cameraController.takePicture();

      // capturedImage.value = photo; // ✅ correct assignment

      // DO NOT manually declare Uint8List
      final bytes = await photo.readAsBytes();

      final image = img.decodeImage(bytes);
      if (image == null) return;

      final flipped = img.flipHorizontal(image);

      // Get app directory
      final directory = await getTemporaryDirectory();

      // Create new file name
      final String newPath = join(
        directory.path,
        'flipped_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final File newFile = File(newPath);

      await newFile.writeAsBytes(img.encodeJpg(flipped));

      print("Flipped Image Path: ${newFile.path}");

      capturedImage.value = XFile(newFile.path);

    } catch (e) {
      debugPrint("Take photo error: $e");
    }
  }

  void retakePhoto() {
    capturedImage.value = null;
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  /// SWITCH CAMERA (photo only)
  Future<void> switchCameraForPhoto() async {
    if (cameras.isEmpty || cameras.length < 2) {
      debugPrint("Only one camera available");
      return;
    }

    // Update current camera index
    currentCameraIndex = (currentCameraIndex + 1) % cameras.length;
    debugPrint('Switching to camera index: $currentCameraIndex');

    try {
      isInitialized.value = false;

      // Dispose previous camera controller if initialized
      if (cameraController.value.isInitialized) {
        await cameraController.dispose();
      }

      // Create new controller for selected camera
      cameraController = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.high,
        enableAudio: false, // photo only, no audio
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      // Lock orientation to portrait for photos
      await cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

      await cameraController.initialize();
      isInitialized.value = true;
    } catch (e) {
      debugPrint("Error switching camera: $e");
    }
  }
}