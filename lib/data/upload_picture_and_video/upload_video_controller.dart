import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/utils/DateHelper.dart';
import 'package:real_true_date/data/upload_picture_and_video/model/photo_list_model.dart';
import 'package:real_true_date/helper/custom_dialog/authenticating_dialog.dart';
import 'package:real_true_date/helper/custom_dialog/common_dialog_view.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


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
  static const int maxSeconds = 10;

  /// Upload simulation
  final RxDouble uploadProgress = 0.0.obs;
  final isVideoUpload = false.obs;
  final isMessage = false.obs;

  /// Video player
  VideoPlayerController? videoPlayer;

  Timer? _timer;
  final cancelToken = CancelToken();
  final sharedPref = SharedPrefHelper();
  RxBool compressingProcessDisplay = false.obs;
  String isComing = '';


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

    final String args = Get.arguments ?? '';
    print('args $args');
    isComing = args;
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
      preferredCameraDevice: CameraDevice.front,
      maxDuration: Duration(seconds: maxSeconds),
    );

    _stopRecording();

    print('result $result');

    if(await _checkAndroidVersion()){
      print('====== Android ======');

      print('result ${result!.path}');

      videoFile.value = File(result.path);
      await _initPlayer(videoFile.value!);

      String fName = path.basename(videoFile.value!.path);
      int fSize = await videoFile.value!.length();

      print('Name: $fName');
      print('Size: ${formatFileSize(fSize)}');
      fileName.value = shortenFileName(fName);
      fileSize.value = formatFileSize(fSize);
      videoUploadApiCall(sessionID);
    }
    else{
      print('====== iOS ======');
      compressingProcessDisplay.value = true;
      iOSVideoCheck(result!);
    }


   /* if (result != null) {
      try {
        // UNCOMMENT these to show conversion state in UI
        // isConverting.value = true;
        // conversionProgress.value = 0.0;

        // IMPORTANT: Don't cancel compression if one is in progress
        // Instead, check if we need to clean up
        try {
          await VideoCompress.cancelCompression();
        } catch (e) {
          // Ignore if no compression to cancel
        }

        // Clear cache but keep track if it's needed
        try {
          await VideoCompress.deleteAllCache();
        } catch (e) {
          // Ignore cache deletion errors
        }

        // Create a progress subscription that can be disposed
        final progressSubscription = VideoCompress.compressProgress$.subscribe((progress) {
          print('Conversion progress: $progress%');
          // conversionProgress.value = progress / 100; // UNCOMMENT this
        });

        // Get local directory for saving
        Directory? localDirectory = await _getLocalDirectory();

        // Create a unique filename with timestamp to avoid conflicts
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String outputPath = '${localDirectory!.path}/video_$timestamp.mp4';

        // Also create a unique temp path for compression to avoid conflicts
        // String tempDir = localDirectory.path;
        // String tempOutputPath = '$tempDir/temp_compressed_$timestamp.mp4';

        print('Saving to: $outputPath');
        print('Original file: ${result.path}');
        print('Original size: ${formatFileSize(await File(result.path).length())}');

        // FORCE COMPRESSION by always using compressVideo
        MediaInfo? compressedInfo = await VideoCompress.compressVideo(
          result.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
          frameRate: 30,
          // Use the temp path to avoid conflicts
        );

        // Always dispose the subscription
        progressSubscription.unsubscribe();

        // Verify compression happened
        if (compressedInfo != null && compressedInfo.path != null) {
          // Get file sizes
          File compressedFile = File(compressedInfo.path!);

          // Make sure the file exists and has content
          if (await compressedFile.exists()) {
            int originalSize = await File(result.path).length();
            int compressedSize = await compressedFile.length();

            print('✅ Compression completed:');
            print('  - Original size: ${formatFileSize(originalSize)}');
            print('  - Compressed size: ${formatFileSize(compressedSize)}');
            print('  - Compression ratio: ${((compressedSize / originalSize) * 100).toStringAsFixed(1)}%');

            // Delete any existing file at outputPath
            File existingFile = File(outputPath);
            if (await existingFile.exists()) {
              await existingFile.delete();
            }

            // Copy the compressed file to our desired location
            File savedFile = await compressedFile.copy(outputPath);

            // Delete the temporary compressed file
            if (await compressedFile.exists() && compressedFile.path != savedFile.path) {
              await compressedFile.delete();
            }

            videoFile.value = savedFile;

            print('✅ Video saved locally:');
            print('  - Path: ${savedFile.path}');
            print('  - Size: ${formatFileSize(await savedFile.length())}');
            print('  - Exists: ${await savedFile.exists()}');

            // Save file info to local storage for later retrieval
            await _saveVideoInfo(savedFile);

            // Save to gallery
            // await _saveToGallery(savedFile);
          } else {
            throw Exception('Compressed file does not exist');
          }
        } else {
          throw Exception('Compression failed - no output file');
        }

      } catch (e) {
        print('Error during conversion: $e');
        // Fallback to original file
        videoFile.value = File(result.path);

        // Show error message to user
        if (Get.context != null) {
          Get.snackbar(
            'Compression Failed',
            'Using original video',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } finally {
        // UNCOMMENT these
        // isConverting.value = false;
        // conversionProgress.value = 0.0;

        // Force a small delay to ensure cleanup
        await Future.delayed(const Duration(milliseconds: 100));
      }
      compressingProcessDisplay.value = false;

      await _initPlayer(videoFile.value!);

      String fName = path.basename(videoFile.value!.path);
      int fSize = await videoFile.value!.length();

      print('Name: $fName');
      print('Size: ${formatFileSize(fSize)}');
      fileName.value = shortenFileName(fName);
      fileSize.value = formatFileSize(fSize);
      videoUploadApiCall(sessionID);
    }*/
  }

  Future<void> iOSVideoCheck(XFile result) async {
    if (result != null) {
      try {
        // UNCOMMENT these to show conversion state in UI
        // isConverting.value = true;
        // conversionProgress.value = 0.0;

        // IMPORTANT: Don't cancel compression if one is in progress
        // Instead, check if we need to clean up
        try {
          await VideoCompress.cancelCompression();
        } catch (e) {
          // Ignore if no compression to cancel
        }

        // Clear cache but keep track if it's needed
        try {
          await VideoCompress.deleteAllCache();
        } catch (e) {
          // Ignore cache deletion errors
        }

        // Create a progress subscription that can be disposed
        final progressSubscription = VideoCompress.compressProgress$.subscribe((progress) {
          print('Conversion progress: $progress%');
          // conversionProgress.value = progress / 100; // UNCOMMENT this
        });

        // Get local directory for saving
        Directory? localDirectory = await _getLocalDirectory();

        // Create a unique filename with timestamp to avoid conflicts
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String outputPath = '${localDirectory!.path}/video_$timestamp.mp4';

        // Also create a unique temp path for compression to avoid conflicts
        // String tempDir = localDirectory.path;
        // String tempOutputPath = '$tempDir/temp_compressed_$timestamp.mp4';

        print('Saving to: $outputPath');
        print('Original file: ${result.path}');
        print('Original size: ${formatFileSize(await File(result.path).length())}');

        // FORCE COMPRESSION by always using compressVideo
        MediaInfo? compressedInfo = await VideoCompress.compressVideo(
          result.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
          frameRate: 30,
          // Use the temp path to avoid conflicts
        );

        // Always dispose the subscription
        progressSubscription.unsubscribe();

        // Verify compression happened
        if (compressedInfo != null && compressedInfo.path != null) {
          // Get file sizes
          File compressedFile = File(compressedInfo.path!);

          // Make sure the file exists and has content
          if (await compressedFile.exists()) {
            int originalSize = await File(result.path).length();
            int compressedSize = await compressedFile.length();

            print('✅ Compression completed:');
            print('  - Original size: ${formatFileSize(originalSize)}');
            print('  - Compressed size: ${formatFileSize(compressedSize)}');
            print('  - Compression ratio: ${((compressedSize / originalSize) * 100).toStringAsFixed(1)}%');

            // Delete any existing file at outputPath
            File existingFile = File(outputPath);
            if (await existingFile.exists()) {
              await existingFile.delete();
            }

            // Copy the compressed file to our desired location
            File savedFile = await compressedFile.copy(outputPath);

            // Delete the temporary compressed file
            if (await compressedFile.exists() && compressedFile.path != savedFile.path) {
              await compressedFile.delete();
            }

            videoFile.value = savedFile;

            print('✅ Video saved locally:');
            print('  - Path: ${savedFile.path}');
            print('  - Size: ${formatFileSize(await savedFile.length())}');
            print('  - Exists: ${await savedFile.exists()}');

            // Save file info to local storage for later retrieval
            await _saveVideoInfo(savedFile);

            // Save to gallery
            // await _saveToGallery(savedFile);
          } else {
            throw Exception('Compressed file does not exist');
          }
        } else {
          throw Exception('Compression failed - no output file');
        }

      } catch (e) {
        print('Error during conversion: $e');
        // Fallback to original file
        videoFile.value = File(result.path);

        // Show error message to user
        if (Get.context != null) {
          Get.snackbar(
            'Compression Failed',
            'Using original video',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } finally {
        // UNCOMMENT these
        // isConverting.value = false;
        // conversionProgress.value = 0.0;

        // Force a small delay to ensure cleanup
        await Future.delayed(const Duration(milliseconds: 100));
      }
      compressingProcessDisplay.value = false;

      await _initPlayer(videoFile.value!);

      String fName = path.basename(videoFile.value!.path);
      int fSize = await videoFile.value!.length();

      print('Name: $fName');
      print('Size: ${formatFileSize(fSize)}');
      fileName.value = shortenFileName(fName);
      fileSize.value = formatFileSize(fSize);
      videoUploadApiCall(sessionID);
    }
  }

  /// Get local directory based on platform
  Future<Directory?> _getLocalDirectory() async {
    Directory? localDirectory;

    if (Platform.isAndroid) {
      // Check storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        // For Android 10+ (API 29+)
        if (await _checkAndroidVersion()) {
          localDirectory = await getExternalStorageDirectory();
        } else {
          localDirectory = await getApplicationDocumentsDirectory();
        }
      } else {
        // Fallback if permission denied
        localDirectory = await getApplicationDocumentsDirectory();
      }
    } else {
      // iOS
      localDirectory = await getApplicationDocumentsDirectory();
    }

    // Create directory if it doesn't exist
    if (localDirectory != null && !await localDirectory.exists()) {
      await localDirectory.create(recursive: true);
    }

    return localDirectory;
  }

  /// Helper function to check Android version
  Future<bool> _checkAndroidVersion() async {
    // Android 10+ (API 29+) uses scoped storage
    return Platform.isAndroid;
  }

  /// Save video info to local storage
  Future<void> _saveVideoInfo(File videoFile) async {
    try {
      // Create a metadata file
      final metadataFile = File('${videoFile.parent.path}/videos_metadata.json');
      Map<String, dynamic> metadata = {};

      if (await metadataFile.exists()) {
        String content = await metadataFile.readAsString();
        metadata = json.decode(content);
      }

      metadata[videoFile.path] = {
        'name': path.basename(videoFile.path),
        'size': await videoFile.length(),
        'created': DateTime.now().toIso8601String(),
      };

      await metadataFile.writeAsString(json.encode(metadata));
      print('✅ Video info saved to metadata');

    } catch (e) {
      print('Error saving video info: $e');
    }
  }

  /// Function to get all saved videos
  Future<List<File>> getSavedVideos() async {
    try {
      Directory? directory = await _getLocalDirectory();

      if (directory != null && await directory.exists()) {
        List<FileSystemEntity> files = directory.listSync();

        return files
            .where((file) =>
        file is File &&
            path.extension(file.path).toLowerCase() == '.mp4')
            .map((file) => file as File)
            .toList();
      }
    } catch (e) {
      print('Error getting saved videos: $e');
    }

    return [];
  }

  /// Save video to gallery using gal package
  // Future<void> recordVideo() async {
  //   print('click video record');
  //   final picker = ImagePicker();
  //
  //   elapsedSeconds.value = 0;
  //   isRecording.value = true;
  //   _startTimer();
  //
  //   final XFile? result = await picker.pickVideo(
  //     source: ImageSource.camera,
  //     preferredCameraDevice: CameraDevice.rear,
  //     maxDuration: const Duration(seconds: maxSeconds),
  //   );
  //
  //   _stopRecording();
  //
  //   if (result != null) {
  //     // sessionID = result["session_id"];
  //     videoFile.value = File(result.path);
  //     await _initPlayer(videoFile.value!);
  //
  //     String fName = path.basename(result.path);
  //     int fSize = await result.length();
  //
  //     print('Name: $fName');
  //     print('Size: ${formatFileSize(fSize)}');
  //     fileName.value = shortenFileName(fName);
  //     fileSize.value = formatFileSize(fSize);
  //     videoUploadApiCall(sessionID);
  //   }
  // }

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
        baseUrl: Endpoints.baseUrl,
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
        // AuthenticatingDialog.showError(response.data['message'],onConfirmCallback: () {
        //   Get.toNamed(Routes.uploadPhotoPage);
        // });
        Get.dialog(
            CommonDialogView(
              title: '',
              message: response.data['message'],
              onConfirm: () {
                Get.toNamed(Routes.uploadPhotoPage, arguments: isComing);
                Get.back();
              },
            )
        );
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
        getChallengesListApiCall();
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
