import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class CustomCameraController extends GetxController {
  CameraController? cameraController;
  var isInitialized = false.obs;
  var isCapturing = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();

      // Select front camera
      final frontCamera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.jpeg,
      );

      await cameraController!.initialize();
      isInitialized.value = true;
    } catch (e) {
      Get.snackbar('Camera Error', 'Failed to initialize camera: $e');
    }
  }

  /// Captures image, bakes orientation, flips horizontally, and returns mirrored File
  Future<File?> captureAndMirrorImage() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      Get.snackbar('Error', 'Camera is not ready');
      return null;
    }

    try {
      isCapturing.value = true;

      XFile xFile = await cameraController!.takePicture();
      File capturedFile = File(xFile.path);

      final List<int> bytes = await capturedFile.readAsBytes();
      img.Image? decodedImg = img.decodeImage(Uint8List.fromList(bytes));

      if (decodedImg != null) {
        // Fix EXIF rotation metadata and flip horizontally
        img.Image bakedImg = img.bakeOrientation(decodedImg);
        img.Image mirroredImg = img.flipHorizontal(bakedImg);

        // Overwrite file with final mirrored JPG bytes
        await capturedFile.writeAsBytes(img.encodeJpg(mirroredImg, quality: 90));
      }

      isCapturing.value = false;
      return capturedFile;
    } catch (e) {
      isCapturing.value = false;
      Get.snackbar('Capture Error', 'Failed to capture image: $e');
      return null;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}