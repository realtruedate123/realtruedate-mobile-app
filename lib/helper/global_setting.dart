
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  /// Static constants (you can hardcode or load dynamically)
  static const String appName = "Real True Date";

  /// Dynamically fetched values (from native build info)
  static String version = "1.0.0";
  static String buildNumber = "1";
  static String packageName = "";
  static String buildSignature = "";

  /// Initialize from package info (call once on startup)
  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
    packageName = info.packageName;
    buildSignature = info.buildSignature;
  }

  /// Helper getter for full version string
  static String get fullVersion => "$version ($buildNumber)";
}
