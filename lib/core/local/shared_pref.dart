import 'dart:convert';
import 'dart:ffi';
// import 'package:luma_expert/core/local/preference_key.dart';
// import 'package:luma_expert/data/model/auth_model.dart';
import 'package:real_true_date/core/local/preference_key.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  Future<void> saveIsLoggedIn(bool value) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setBool(PreferenceKeys.isLoggedIn, value);
  }

  Future<bool> get isLoggedIn async {
    final preference = await SharedPreferences.getInstance();
    return preference.getBool(PreferenceKeys.isLoggedIn) ?? false;
  }

  Future<void> saveIsEmailVerified(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferenceKeys.isEmailVerified, value);
  }

  Future<void> saveIsPhoneVerified(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferenceKeys.isPhoneVerified, value);
  }

  Future<bool> get isEmailVerified async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferenceKeys.isEmailVerified) ?? false;
  }

  Future<bool> get isPhoneVerified async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferenceKeys.isPhoneVerified) ?? false;
  }

  Future<void> saveBookingId(List<String> id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('booking_id', id);
  }

  Future<List<String>> getBookingId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('booking_id') ?? [];
  }

  Future<void> clearBookingId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('booking_id');
  }

  Future<void> saveAvailabilityStatus(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('availability_status', value);
  }

  Future<String?> getAvailabilityStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('availability_status');
  }

  Future<void> saveUserId(String value) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(PreferenceKeys.userId, value);
  }

  Future<String> get getUserId async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(PreferenceKeys.userId) ?? '';
  }

  Future<void> saveAuthToken(String value) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(PreferenceKeys.authToken, value);
  }

  Future<String> get getAuthToken async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(PreferenceKeys.authToken) ?? '';
  }

  Future<void> saveRefreshAuthToken(String value) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(PreferenceKeys.refreshAuthToken, value);
  }

  Future<String> get getRefreshAuthToken async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(PreferenceKeys.refreshAuthToken) ?? '';
  }

  Future<void> savePersonList(DataModel person) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert model to JSON string directly
    final userJson = jsonEncode(person.toJson());
    await prefs.setString(PreferenceKeys.userData, userJson);
  }

  Future<DataModel?> getPersonList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(PreferenceKeys.userData);

    if (jsonString != null && jsonString.isNotEmpty) {
      // Parse JSON string to map, then to model
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return DataModel.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> saveFirebaseToken(String value) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(PreferenceKeys.firebaseToken, value);
  }

  Future<String> get getFirebaseToken async{
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(PreferenceKeys.firebaseToken) ?? '';
  }
  Future<void> saveApiToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("api_token", token);
  }

  Future<String> getApiToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("api_token") ?? "";
  }

  /// Video verification flag
  Future<void> saveVideoVerificationFlag(bool flag) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isVideoVerify", flag);
  }

  Future<bool> getVideoVerificationFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isVideoVerify") ?? false;
  }

  /// Save OneSignal ID
  Future<void> savePushSubscription(String value) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setString(PreferenceKeys.firebaseToken, value);
  }

  Future<String> get getPushSubscription async {
    final preference = await SharedPreferences.getInstance();
    return preference.getString(PreferenceKeys.firebaseToken) ?? '';
  }

  /// Save User location
  Future<void> saveUserLocation(Map<String, String> data) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await preference.setString(PreferenceKeys.location, jsonString);
  }

  Future<Map<String, String>> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(PreferenceKeys.location);

    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    // Convert dynamic map to <String, String>
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Save object
  Future<void> saveObject(Map<String, String> data) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await preference.setString(PreferenceKeys.object, jsonString);
  }

  Future<Map<String, String>> getObject() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(PreferenceKeys.object);

    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    // Convert dynamic map to <String, String>
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  void clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferenceKeys.userData);
    await prefs.remove(PreferenceKeys.isLoggedIn);
    await prefs.remove(PreferenceKeys.authSession);
    await prefs.remove(PreferenceKeys.userId);
    await prefs.remove(PreferenceKeys.phoneNumber);
  }
}