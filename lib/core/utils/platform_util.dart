import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter/cupertino.dart';

class PlatformUtil {
  // static const String _deviceIdKey = "device_id";

  static int getRequestFrom() {
    if (Platform.isAndroid) {
      return 1; // Android
    } else if (Platform.isIOS) {
      return 2; // iOS
    }
    return 0; // Default/Other platforms
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static String getPlatformName() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    }
    return 'Other';
  }

  static Future<String> getDeviceId() async {
    final deviceMarketingNames = DeviceMarketingNames();
    final currentSingleDeviceName = await deviceMarketingNames.getSingleName();
    // final currentDeviceNames = await deviceMarketingNames.getNames();

    // print('currentSingleDeviceName ${currentSingleDeviceName}');
    // print('currentDeviceNames ${currentDeviceNames}');

    return currentSingleDeviceName;

    /*if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      // For Android 8.0 (API 26) and below
      if (androidInfo.version.sdkInt <= 26) {
        return androidInfo.model; // e.g. "Moto G (4)"
      }
    } else if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.model; // e.g. "iPod7,1"
    }
    return "Android"; // Default/Other platforms*/
  }

  static Future<String> getDeviceUDID() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        final id = androidInfo.id;
        final model = androidInfo.model;
        final brand = androidInfo.brand;
        final version = androidInfo.version.release;

        // Combine into one readable string
        debugPrint("$brand $model ($version) - $id");
        return id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        final id = iosInfo.identifierForVendor ?? "UnknownID";
        final model = iosInfo.utsname.machine;
        final name = iosInfo.name;
        final version = iosInfo.systemVersion;
        debugPrint("$name $model ($version) - $id");
        return id;
      } else {
        return "Unsupported Platform";
      }
    } catch (e) {
      debugPrint("❌ Error getting device info: $e");
      return "Error";
    }
  }
}