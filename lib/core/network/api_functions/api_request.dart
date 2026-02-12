import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/network/check_connectivity.dart';
import 'package:real_true_date/data/login_signup/model/register_model.dart';
import 'package:real_true_date/helper/common_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class BaseApiService {
  // final String baseUrl;

  // BaseApiService({required key});
  // final connectivity = Get.find<ConnectivityService>();

  /// Checked internet connectivity
  /*Future<bool> checkInternet() async {
    print('No Internet 1 ${connectivity.isConnected}');
    if (!connectivity.isConnected) {
      print('No Internet');
      EasyLoading.dismiss();

      // Get.defaultDialog(
      //   title: 'No Internet',
      //   middleText: 'Please check your internet connection and try again.',
      //   textConfirm: 'OK',
      //   confirmTextColor: Colors.white,
      //   onConfirm: () => Get.back(),
      // );

      return false;
    }
    return true;
  }
*/

  Future<bool> checkInternet() async {
    final isConnected = await ConnectivityService.isOnline();
    if (!isConnected) {
      EasyLoading.dismiss();
      // Get.snackbar(
      //   "No Internet",
      //   "Please check your internet connection",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: Duration(seconds: 2),
      // );
    }
    return isConnected;
  }


  /// Generic JSON API call
  Future<T?> callApi<T>({
    required String endpoint,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    /// Check Internet
    if (!await checkInternet()) return null;  // <---- Add THIS

    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black, // Disables touch events
    );
    try {
      final url = Uri.parse('${Endpoints.baseUrl}$endpoint');
      http.Response response;

      switch (method.toUpperCase()) {
        case "POST":
          response = await http.post(
            url,
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          );
          break;
        case "PUT":
          response = await http.put(
            url,
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          );
          break;
        case "DELETE":
          response = await http.delete(
            url,
            headers: headers ?? {'Content-Type': 'application/json'},
          );
          break;
        default: // GET
          response = await http.get(
            url,
            headers: headers ?? {'Content-Type': 'application/json'},
          );
      }
      EasyLoading.dismiss();
      return _handleResponse(response, fromJson);
    } catch (e) {
      debugPrint("❌ API error: $e");
      EasyLoading.dismiss();
      return null;
    }
  }

  /// Multipart / Form-Data API (for file upload)
  Future<T?> uploadMultipart<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, String>? fields,
    File? file, // optional
    String fileField = "file",
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    /// Check Internet
    if (!await checkInternet()) return null;  // <---- Add THIS

    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black, // Disables touch events
    );
    try {
      final url = Uri.parse('${Endpoints.baseUrl}$endpoint');
      final request = http.MultipartRequest("POST", url);

      // Add headers
      if (headers != null) request.headers.addAll(headers);

      // Add form fields
      if (fields != null) request.fields.addAll(fields);

      // Attach file if provided
      if (file != null) {
        final multipartFile = await http.MultipartFile.fromPath(fileField, file.path);
        request.files.add(multipartFile);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, fromJson);
    } catch (e) {
      debugPrint("❌ Multipart API error: $e");
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Form-Data API
  Future<ApiResponse<T>> formData<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, String>? fields,
    bool showLoader = true,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    /// Check Internet
    if (!await checkInternet()) {
      return ApiResponse<T>(
        statusCode: 0,
        message: "Please check your internet connection and try again.",
        data: null,
      );
    }

    if (showLoader) {
      EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black, // Disables touch events
     );
    }
    try {
      final url = Uri.parse('${Endpoints.baseUrl}$endpoint');
      final request = http.MultipartRequest("POST", url);

      if (headers != null) request.headers.addAll(headers);
      if (fields != null) request.fields.addAll(fields);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final statusCode = response.statusCode;
      final body = response.body;

      try {
        final Map<String, dynamic> jsonData = jsonDecode(body);

        if (statusCode >= 200 && statusCode < 300) {
          debugPrint(" Form-data API data: ${jsonData['data']}");
          // ✅ Success
          return ApiResponse(
            statusCode: statusCode,
            data: fromJson(jsonData),
            message: jsonData['message'] ?? "Success",
          );
        } else {
          // ❌ API Error
          return ApiResponse(
            statusCode: statusCode,
            message: jsonData['message'] ?? "Something went wrong",
            data: null,
              tokenExpired: jsonData['token_expired'] ?? false
          );
        }
      } catch (e) {
        debugPrint('URL: $endpoint');
        // ❌ Invalid JSON
        return ApiResponse(
          statusCode: statusCode,
          message: "Invalid JSON: $body",
          data: null,
        );
      }
    } catch (e) {
      debugPrint("❌ Form-data API error: $e");
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: null,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Row Data
  Future<ApiResponse<T>> postRawData<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? fields, // raw JSON body
    bool showLoader = true,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    /// Check Internet
    if (!await checkInternet()) {
      return ApiResponse<T>(
        statusCode: 0,
        message: "Please check your internet connection and try again.",
        data: null,
      );
    }

    if (showLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    try {
      final url = Uri.parse('${Endpoints.baseUrl}$endpoint');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (headers != null) ...headers,
        },
        body: fields != null ? jsonEncode(fields) : null,
      );

      final statusCode = response.statusCode;
      final responseBody = response.body;

      try {
        final Map<String, dynamic> jsonData = jsonDecode(responseBody);
        debugPrint("Raw API data: $jsonData");

        if (statusCode >= 200 && statusCode < 300) {
          debugPrint("Raw API data: ${jsonData['data']}");
          return ApiResponse<T>(
            statusCode: statusCode,
            data: fromJson(jsonData),
            message: jsonData['message'] ?? "Success",
          );
        } else {
          return ApiResponse<T>(
            statusCode: statusCode,
            message: jsonData['message'] ?? "Something went wrong",
            data: null,
              tokenExpired: jsonData['token_expired'] ?? false
          );
        }
      } catch (e) {
        debugPrint('URL: $endpoint');
        return ApiResponse<T>(
          statusCode: statusCode,
          message: "Invalid JSON: $responseBody",
          data: null,
        );
      }
    } catch (e) {
      debugPrint("❌ Raw POST API error: $e");
      return ApiResponse<T>(
        statusCode: 500,
        message: e.toString(),
        data: null,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ApiResponse<T>> sendRequest<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, String>? headers,
    Map<String, dynamic>? fields, // JSON body
    Map<String, dynamic>? queryParams, // query string
    bool showLoader = true,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    /// Check Internet
    if (!await checkInternet()) {
      return ApiResponse<T>(
        statusCode: 0,
        message: "Please check your internet connection and try again.",
        data: null,
      );
    }

    if (showLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    try {
      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint').replace(
        queryParameters: queryParams?.map(
              (key, value) => MapEntry(key, value.toString()),
        ),
      );

      http.Response response;

      final requestHeaders = {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };

      switch (method) {
        case HttpMethod.post:
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: fields != null ? jsonEncode(fields) : null,
          );
          break;

        case HttpMethod.put:
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: fields != null ? jsonEncode(fields) : null,
          );
          break;

        case HttpMethod.delete:
          response = await http.delete(
            uri,
            headers: requestHeaders,
            body: fields != null ? jsonEncode(fields) : null,
          );
          break;

        case HttpMethod.get:
          response = await http.get(
            uri,
            headers: requestHeaders,
          );
          break;
      }

      final statusCode = response.statusCode;
      final responseBody = response.body;

      try {
        final Map<String, dynamic> jsonData = jsonDecode(responseBody);
        debugPrint("Raw API data: $jsonData");

        if (statusCode >= 200 && statusCode < 300) {
          return ApiResponse<T>(
            statusCode: statusCode,
            data: fromJson(jsonData),
            message: jsonData['message'] ?? "Success",
          );
        } else {
          return ApiResponse<T>(
            statusCode: statusCode,
            message: jsonData['message'] ?? "Something went wrong",
            data: null,
              tokenExpired: jsonData['token_expired'] ?? false
          );
        }
      } catch (e) {
        debugPrint('URL: $endpoint');
        return ApiResponse<T>(
          statusCode: statusCode,
          message: "Invalid JSON: $responseBody",
          data: null,
        );
      }
    } catch (e) {
      debugPrint("❌ API error: $e");
      return ApiResponse<T>(
        statusCode: 500,
        message: e.toString(),
        data: null,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Unified API call
  Future<ApiResponse<T>> formDataWithFile<T>({
    required String endpoint,
    String method = "POST", // GET, POST, PUT, DELETE
    Map<String, String>? headers,
    Map<String, String>? fields, // form fields
    Map<String, dynamic>? body, // for JSON request
    File? file, // optional File object
    String? filePath, // optional file path string
    String fileField = "file", // form field name
    required T Function(Map<String, dynamic>) fromJson,
    bool saveLocal = false,
    bool isLoading = true
  }) async {
    /// Check Internet
    if (!await checkInternet()) {
      return ApiResponse<T>(
        statusCode: 0,
        message: "Please check your internet connection and try again.",
        data: null,
      );
    }

    if(isLoading){
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    try {
      http.Response response;

      // ✅ Determine if it's a multipart/form-data request
      final hasMultipart = (fields != null && fields.isNotEmpty) ||
          file != null ||
          (filePath != null && filePath.isNotEmpty);

      if (hasMultipart) {
        final url = Uri.parse("${Endpoints.baseUrl}$endpoint");
        final request = http.MultipartRequest(method, url);

        if (headers != null) request.headers.addAll(headers);
        if (fields != null) request.fields.addAll(fields);

        // ✅ Handle file logic (safe for nulls)
        if (file != null) {
          // Upload File object
          request.files.add(await http.MultipartFile.fromPath(fileField, file.path));
          debugPrint("📤 Uploading File: ${file.path}");
        } else if (filePath != null && filePath.isNotEmpty) {
          if (filePath.startsWith('http')) {
            // 🌐 Remote URL — just send as form field
            request.fields[fileField] = filePath;
            debugPrint("🌐 Using remote image URL: $filePath");
          } else {
            // 📁 Local file path
            final fileToUpload = File(filePath);
            if (await fileToUpload.exists()) {
              request.files.add(
                await http.MultipartFile.fromPath(fileField, filePath),
              );
              debugPrint("📂 Uploading local file path: $filePath");
            } else {
              debugPrint("⚠️ File does not exist at: $filePath");
            }
          }
        } else {
          debugPrint("ℹ️ No file provided — skipping upload.");
        }

        final streamed = await request.send();
        response = await http.Response.fromStream(streamed);
      } else {
        // ✅ Regular JSON API request
        final url = Uri.parse("${Endpoints.baseUrl}$endpoint");

        switch (method.toUpperCase()) {
          case "GET":
            response = await http.get(url, headers: headers);
            break;
          case "PUT":
            response = await http.put(
              url,
              headers: headers ?? {'Content-Type': 'application/json'},
              body: jsonEncode(body ?? {}),
            );
            break;
          case "DELETE":
            response = await http.delete(url, headers: headers);
            break;
          default:
            response = await http.post(
              url,
              headers: headers ?? {'Content-Type': 'application/json'},
              body: jsonEncode(body ?? {}),
            );
        }
      }

      // ✅ Safely parse and handle response
      final jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;
      final model = fromJson(jsonData);

      debugPrint('hasMultipart $model');

      // ✅ Save locally if required
      if (saveLocal) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userJson", jsonEncode(jsonData));
      }

      debugPrint("✅ API upload success: $endpoint");
      debugPrint("✅ API upload success: ${jsonData['message']?.toString() ?? "Success"}");

      if (statusCode >= 200 && statusCode < 300) {
        debugPrint("$endpoint ✅ GET API Success: ${jsonData['data']}");
        return ApiResponse(
          statusCode: statusCode,
          data: model,
          message: jsonData['message']?.toString() ?? "Success",
        );
      } else {
        debugPrint("❌ GET API Error: $body");
        return ApiResponse(
            statusCode: statusCode,
            message: jsonData['message'] ?? "Something went wrong",
            data: null,
            tokenExpired: jsonData['token_expired'] ?? false
        );
      }
    } catch (e, s) {
      debugPrint('URL: $endpoint');
      debugPrint("❌ API upload error: $e\n$s");
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: null,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Refresh token api
  Future<ApiResponse> refreshToken({
    bool showLoader = true,
  }) async {
    /// Check Internet
    if (!await checkInternet()) {
      return ApiResponse(
        statusCode: 0,
        message: "Please check your internet connection and try again.",
        data: null,
      );
    }

    final refreshToken = await SharedPrefHelper().getRefreshAuthToken;

    try {
      final params = {"refresh": refreshToken};
      print('refresh token params $params');
      if (showLoader) {
        EasyLoading.show(
          status: 'Loading...',
          maskType: EasyLoadingMaskType.black,
        );
      }

      final response = await BaseApiService().formData<Tokens>(
        endpoint: Endpoints.refreshToken,
        fields: params,
        fromJson: (json) => Tokens.fromJson(json),
      );

      if (showLoader) EasyLoading.dismiss();

      if (response.isSuccess) {
        await Future.wait([
          // sharedPref.saveIsLoggedIn(true),
          SharedPrefHelper().saveRefreshAuthToken(response.data?.refresh ?? ''),
          SharedPrefHelper().saveAuthToken(response.data?.access ?? '')
        ]);

        return ApiResponse(
          statusCode: response.statusCode,
          data: response,
          message:response.message ?? "token",
        );
      } else {
        return ApiResponse(
          statusCode: response.statusCode,
          data: null,
          message:response.message ?? "Failed",
        );
      }
    } catch (e) {
      if (showLoader) EasyLoading.dismiss();
      return ApiResponse(
        statusCode: 500,
        data: null,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<T>> getMethod<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    bool showLoader = true,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    /// Check Internet
    if (!await checkInternet()) {
      return ApiResponse<T>(
        statusCode: 0,
        message: "Please check your internet connection and try again.",
        data: null,
      );
    }

    if (showLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    try {
      // Build URL with query parameters
      final uri = Uri.parse('${Endpoints.baseUrl}$endpoint').replace(queryParameters: queryParams);
      debugPrint("$headers 📡 GET Request: $uri");

      final response = await http.get(uri, headers: headers);
      final statusCode = response.statusCode;
      final body = response.body;

      try {
        final Map<String, dynamic> jsonData = jsonDecode(body);

        if (showLoader) EasyLoading.dismiss();
        if (statusCode >= 200 && statusCode < 300) {
          debugPrint("$endpoint ✅ GET API Success: ${jsonData['data']}");
          return ApiResponse(
            statusCode: statusCode,
            data: fromJson(jsonData),
            message: jsonData['message'] ?? "Success",
          );
        } else {
          debugPrint("❌ GET API Error: $body");
          return ApiResponse(
            statusCode: statusCode,
            message: jsonData['message'] ?? "Something went wrong",
            data: null,
            tokenExpired: jsonData['token_expired'] ?? false
          );
        }
      } catch (e) {
        if (showLoader) EasyLoading.dismiss();
        debugPrint('URL: $endpoint');
        debugPrint("⚠️ JSON Decode Error: $e");
        return ApiResponse(
          statusCode: statusCode,
          message: "Invalid JSON: $body",
          data: null,
        );
      }
    } catch (e) {
      if (showLoader) EasyLoading.dismiss();
      debugPrint("❌ GET API Exception: $e");
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: null,
      );
    } finally {
      if (showLoader) EasyLoading.dismiss();
    }
  }

  /// Centralized Response Handler
  T? _handleResponse<T>(
      http.Response response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    debugPrint("📡 Response [${response.statusCode}]: ${response.body}");

    if (response.statusCode == 401) {
      // 🔑 Handle unauthorized globally
      debugPrint("⚠️ Unauthorized. Logging out...");
      // e.g. clear token, redirect to login page
      return null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      return fromJson(jsonData);
    } else {
      throw Exception("API Error: ${response.statusCode} → ${response.body}");
    }
  }

  /// File uploading with progress
  Future<ApiResponse<T>> uploadWithDio<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? fields,
    // List<File>? files,
    File? file,
    String fileField = "files",
    Map<String, String>? headers,
    CancelToken? cancelToken,
    void Function(double progress, Duration remaining)? onProgress,
  }) async {
    if (!await checkInternet()) {
      return ApiResponse(
        statusCode: 0,
        message: "Please check your internet connection",
        data: null,
      );
    }

    // EasyLoading.show(status: "Uploading...");

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          headers: headers,
        ),
      );

      final formData = FormData();

      /// Add fields
      // if (fields != null && fields.isNotEmpty) {
      //   fields.forEach((key, value) {
      //     formData.fields.add(MapEntry(key, value.toString()));
      //   });
      // }

      /// Add multiple files
      if (file != null) {
        formData.files.add(
          MapEntry(
            fileField,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      final stopwatch = Stopwatch()..start();

      final response = await dio.post(
        endpoint,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total <= 0) return;

          final progress = sent / total;

          if (onProgress != null && stopwatch.elapsedMilliseconds > 0) {
            final speed = sent / stopwatch.elapsedMilliseconds; // bytes/ms
            final remainingBytes = total - sent;
            final remainingMs = (remainingBytes / speed).round();

            onProgress(
              progress.clamp(0.0, 1.0),
              Duration(milliseconds: remainingMs),
            );
          }
        },
      );

      final jsonData = response.data;
      final statusCode = response.statusCode;

      if (statusCode! >= 200 && statusCode < 300) {
        debugPrint("$endpoint ✅ GET API Success: ${jsonData['data']}");
        return ApiResponse<T>(
          statusCode: response.statusCode ?? 200,
          message: jsonData['message'] ?? "Success",
          data: fromJson(jsonData),
        );
      } else {
        debugPrint("❌ GET API Error: ${jsonData['data']}");
        return ApiResponse(
            statusCode: statusCode,
            message: jsonData['message'] ?? "Something went wrong",
            data: null,
            tokenExpired: jsonData['token_expired'] ?? false
        );
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("❌ GET API Error catch: $e");
        return ApiResponse(
          statusCode: 499,
          message: "Upload cancelled",
          data: null,
        );
      }

      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message ?? "Upload failed",
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: null,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}

class ApiResponse<T> {
  final int statusCode;
  final String? message;
  final T? data;
  final bool? tokenExpired;

  ApiResponse({
    required this.statusCode,
    this.message,
    this.data,
    this.tokenExpired = false,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}


/*
Upload file + params
final response = await uploadMultipart<UserProfile>(
  endpoint: "user/uploadProfile",
  fields: {"userId": "12345"},
  file: File("/path/to/image.jpg"),
  fileField: "profileImage",
  fromJson: (json) => UserProfile.fromJson(json),
);

Only send form fields (no file)
final response = await uploadMultipart<UserProfile>(
  endpoint: "user/updateProfile",
  fields: {"userId": "12345", "name": "John Doe"},
  fromJson: (json) => UserProfile.fromJson(json),
);
 */