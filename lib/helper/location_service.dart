import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ElevatedButton, AlertDialog, TextButton, showDialog;
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/utils/singleton.dart';

/// A reusable location service wrapper class
/// Handles permission, error cases, and returns current location cleanly.
class LocationService {
  static Future<Position?>? _activeRequest;
  static bool _openingSettings = false;

  /// Request location permission and get current location.
  static Future<Position?> getCurrentLocation() async {
    if (_activeRequest != null) {
      // Avoid re-entry
      debugPrint('⚠️ Permission request already running.');
      return await _activeRequest;
    }

    final completer = Completer<Position?>();
    _activeRequest = completer.future;

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
        final shouldOpenSettings = await showDialog<bool>(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Location Permission Required'),
              content: const Text(
                'Location permission is permanently denied. '
                    'Please enable it from app settings.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _openingSettings = false;
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _openingSettings = true;
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text('Settings'),
                ),
              ],
            );
          },
        );

        if (shouldOpenSettings == true) {
          await Geolocator.openAppSettings();

          permission = await Geolocator.checkPermission();
          if (permission != LocationPermission.always &&
              permission != LocationPermission.whileInUse) {
            throw Exception('Location permission is still denied.');
          }
        } else {
          if (_openingSettings) {
            _openingSettings = false;
              final position = await Geolocator.getCurrentPosition(
                  locationSettings: LocationSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 100, // meters to move before update
                  )
              );
            Get.back();
              if (position.longitude != 0.0) {
                AppState.instance.userLat = position.latitude;
                AppState.instance.userLong = position.longitude;
                await Future.wait([
                  SharedPrefHelper().saveUserLocation({'Latitude': position.latitude.toString(), 'Longitude': position.longitude.toString()}),
                ]);
              }
          }
          throw Exception('Location permission is permanently denied.');
        }
      }

      // ✅ 3. Get current position
      final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100, // meters to move before update
          )
      );

      // ✅ 3. Get current position
      completer.complete(position);
      return position;

    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
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
