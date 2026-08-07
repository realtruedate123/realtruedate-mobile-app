import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

/// A reusable location service wrapper class
/// Handles permission, error cases, and returns current location cleanly.
class LocationService {
  // static bool _isRequestingPermission = false;
  static Future<Position?>? _activeRequest;

  /// Request location permission and get current location.
  static Future<Position?> getCurrentLocation() async {
    if (_activeRequest != null) {
      // Avoid re-entry
      debugPrint('⚠️ Permission request already running.');
      return await _activeRequest;
    }

    final completer = Completer<Position?>();
    _activeRequest = completer.future;

    // _isRequestingPermission = true;
    try {

      // ✅ 1. Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location services are disabled.');
      }

      // ✅ 2. Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, cannot request.');
      }

      // ✅ 3. Get current position
      final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100, // meters to move before update
          )
      );

      // ✅ 3. Get current position
      // return await Geolocator.getCurrentPosition(
      //   locationSettings: LocationSettings(
      //     accuracy: LocationAccuracy.high,
      //     distanceFilter: 100, // meters to move before update
      //   ),
      // );
      completer.complete(position);
      return position;

    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      // _isRequestingPermission = false; // release lock
      _activeRequest = null; // ✅ release for next call
    }
  }

  /// Get continuous location stream (optional)
  static Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Open app settings manually
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Open location settings manually
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
