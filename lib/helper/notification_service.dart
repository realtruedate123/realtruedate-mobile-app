import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:real_true_date/core/local/shared_pref.dart';

// 1️⃣ Firebase Messaging background handler
@pragma('vm:entry-point') // Required for background execution
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("📩 Background message ID: ${message.messageId}");
  debugPrint("Data: ${message.data}");
}

// 2️⃣ Local Notifications background tap handler
@pragma('vm:entry-point') // Required for background execution
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('🔔 Notification tapped (background): ${notificationResponse.payload}');

  if ((notificationResponse.payload ?? '').isNotEmpty) {
    try {
      final Map<String, dynamic> messagePayload =
      json.decode(notificationResponse.payload!);

      // Note: Make sure any navigation/state logic used inside redirect
      // can safely handle execution in background isolates.
      debugPrint('Payload parsed: $messagePayload');
      // redirectFromNotification(messagePayload);

    } catch (e) {
      debugPrint('Failed to parse notification payload: $e');
    }
  }
}

class NotificationService {
  final sharedPref = SharedPrefHelper();

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((final RemoteMessage message) {
      try {
        redirectFromNotification(message.data);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    getFCMToken();
    enableIOSNotifications();
    await registerNotificationListeners();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void getFCMToken() {
    FirebaseMessaging.instance.getToken().then((final String? value) {
      debugPrint('FIREBASE TOKEN==>$value');
      sharedPref.saveFirebaseToken(value ?? '');
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((final String newToken) {
      debugPrint('FIREBASE TOKEN==>$newToken');
      sharedPref.saveFirebaseToken(newToken);
    });
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);

    flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (final NotificationResponse details) {
        if ((details.payload ?? '').isNotEmpty) {
          final Map<String, dynamic> messagePayload =
          json.decode((details.payload ?? ''));
          redirectFromNotification(messagePayload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      // onDidReceiveBackgroundNotificationResponse:
      //     (final NotificationResponse details) {
      //   if ((details.payload ?? '').isNotEmpty) {
      //     final Map<String, dynamic> messagePayload =
      //     json.decode(details.payload ?? '');
      //     redirectFromNotification(messagePayload);
      //   }
      // },
    );

    FirebaseMessaging.onMessage.listen((final RemoteMessage? message) async {
      try {
        final RemoteNotification? notification = message!.notification;

        if (notification != null) {
          debugPrint('notification Data${message.data}');
          debugPrint('notification title${message.notification?.title}');
          debugPrint('notification body${message.notification?.body}');

          if (Platform.isAndroid) {
            await flutterLocalNotificationsPlugin.show(
              id: notification.hashCode,
              title: message.notification?.title,
              body: message.notification?.body,
              payload: jsonEncode((message.data)),
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  color: Color(0xFF3E80FA),
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@drawable/ic_notification',
                ),
              ),
            );
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

  void redirectFromNotification(final Map<String, dynamic> payload) async {
    //redirect to any specific screen.
    //if (sharedPref.isLoggedIn) {
    // final RedirectData redirectData = RedirectData.fromJson(payload);
    // }
  }
}
