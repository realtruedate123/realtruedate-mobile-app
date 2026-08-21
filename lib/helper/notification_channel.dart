import 'dart:async';

import 'package:flutter/services.dart';

class IOSNotificationChannel {
  IOSNotificationChannel._();

  static const MethodChannel _channel =
  MethodChannel('com.truedate/notification');

  static final StreamController<Map<String, dynamic>>
  _notificationController =
  StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get onNotification =>
      _notificationController.stream;

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotification') {
        final payload = Map<String, dynamic>.from(
          call.arguments as Map,
        );

        print('iOS notification payload: $payload');

        _notificationController.add(payload);
      }
    });
  }

  static Future<Map<String, dynamic>?> getInitialNotification() async {
    try {
      final result = await _channel.invokeMethod(
        'getInitialNotification',
      );

      if (result == null) {
        return null;
      }

      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      print(
        'getInitialNotification error: '
            '${e.code} - ${e.message}',
      );

      return null;
    }
  }
}