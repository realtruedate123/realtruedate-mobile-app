import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/notification_channel.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1️⃣ Firebase Messaging background handler
@pragma('vm:entry-point') // Required for background execution
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("📩 Background message ID: ${message.messageId}");
  debugPrint("Data: ${message.data}");
  // await NotificationService.showLocalNotification(message);
}

// 2️⃣ Local Notifications background tap handler
@pragma('vm:entry-point') // Required for background execution
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('🔔 Notification tapped (background): ${notificationResponse.payload}');
}

class NotificationService {
  final sharedPref = SharedPrefHelper();
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // 1️⃣ Global storage for pending killed-state redirect
  static Map<String, dynamic>? pendingKilledPayload;

  Future<void> setupInteractedMessage() async {
    // Request permissions first
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    enableIOSNotifications();
    await registerNotificationListeners();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // SAFELY FETCH INITIAL MESSAGE (Non-blocking for iOS)
    _checkInitialMessageSafely();

    // _listenNotification();
    // _getInitialNotification();
    // _checkStoredNotification();

    // Fetch token after permissions are handled
    await getFCMToken();

    FirebaseMessaging.onMessageOpenedApp.listen((final RemoteMessage message) {
      debugPrint("📱 App opened from BACKGROUND state");
      try {
        redirectFromNotification(message.data);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  // NEW: Setup native notification channel
 /* void _listenNotification() {
    IOSNotificationChannel.onNotification.listen((payload) {
      print('LIVE NOTIFICATION: $payload');

      final type = payload['type'];
      final chatId = payload['chat_id'];
      final screen = payload['screen'];

      print('type: $type');
      print('chatId: $chatId');
      print('screen: $screen');
    });
  }

  Future<void> _getInitialNotification() async {
    final payload = await IOSNotificationChannel.getInitialNotification();

    if (payload != null) {
      print('INITIAL NOTIFICATION: $payload');

      // App was opened from notification.
    }
  }*/

  void _checkInitialMessageSafely() {
    // Microtask ensures this runs without blocking app initialization/rendering
    Future.microtask(() async {
      try {
        // 1️⃣ KILLED STATE TAP: App opened from completely closed state
        final RemoteMessage? initialMessage = await FirebaseMessaging.instance
            .getInitialMessage()
            .timeout(const Duration(seconds: 3));

        if (initialMessage != null) {
          debugPrint("🚀 App opened from KILLED state via notification tap");
          pendingKilledPayload = initialMessage.data;
        }
      } catch (e) {
        debugPrint("getInitialMessage safely ignored error/timeout: $e");
      }
    });
  }

  // Helper function to consume the stored payload when UI is ready
  static Future<void> processPendingNotification() async {
    if (pendingKilledPayload != null) {
      debugPrint("⚡ Processing deferred killed-state notification payload...");
      final payload = pendingKilledPayload!;
      pendingKilledPayload = null; // Clear to prevent double navigation

      await Future.delayed(const Duration(seconds: 1));
      // Execute redirect logic
      NotificationService().redirectFromNotification(payload);
    }
  }

  Future<void> getFCMToken() async {
    try {
      if (Platform.isIOS) {
        // 1. Check if APNs token is already available
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        // 2. If null, wait briefly for APNs to complete registration
        int retries = 0;
        while (apnsToken == null && retries < 5) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          retries++;
        }

        if (apnsToken == null) {
          debugPrint('⚠️ APNs token is still null after retries. Skipping getToken for now.');
          return;
        }
      }

      // Fetch FCM token once APNs is confirmed (or immediately on Android)
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('FIREBASE TOKEN ==> $fcmToken');
      if (fcmToken != null) {
        await sharedPref.saveFirebaseToken(fcmToken);
      }
    } catch (e) {
      debugPrint('Error getting FCM Token: $e');
    }

    // Listen for token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((final String newToken) {
      debugPrint('FIREBASE TOKEN REFRESH ==> $newToken');
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
        debugPrint(" Foreground Local Notification Tapped: ${details.payload}");
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> messagePayload = jsonDecode(details.payload!);
            redirectFromNotification(messagePayload);
          } catch (e) {
            debugPrint("Error parsing payload: $e");
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen((final RemoteMessage? message) async {
      try {
        if (message == null) return;
        debugPrint('Received foreground FCM message: ${message.data}');
        final RemoteNotification? notification = message.notification;
        final title = notification?.title ?? message.data['title'];
        final body = notification?.body ?? message.data['body'];

        if (title != null && body != null) {
          debugPrint('notification Data${message.data}');
          debugPrint('notification title${message.notification?.title}');
          debugPrint('notification body${message.notification?.body}');

          // Trigger local notification show on BOTH Android and iOS
          if (Platform.isAndroid || (Platform.isIOS && message.notification == null)) {
            await flutterLocalNotificationsPlugin.show(
              id: notification.hashCode,
              title: title,
              body: body,
              payload: jsonEncode(message.data),
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: const Color(0xFF3E80FA),
                  icon: '@drawable/ic_notification',
                  // 🔴 REQUIRED FOR ANDROID FOREGROUND HEADS-UP BANNER
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
                // 🔴 REQUIRED FOR IOS LOCAL NOTIFICATION FOREGROUND BANNER
                iOS: const DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                  sound: 'default', // 🔑 Fixes missing sound on iOS foreground local notifications
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

  /// Show local notification (foreground/background)
  static Future<void> showLocalNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];

    if (title == null || body == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: Color(0xFF333333),
    );

      final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true, // 🔑 show banner in foreground
        presentBadge: true,
        presentSound: true,
        sound: 'default', // 🔑 Fixes missing sound on iOS foreground local notifications
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

    await _localNotificationsPlugin.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: json.encode(message.data),
    );
  }

  Future<void> redirectFromNotification(Map<String, dynamic> payload) async {
    //redirect to any specific screen.
    print('payload $payload');

    try {
      final user = await sharedPref.getPersonList();
      if (user?.user?.id?.isNotEmpty ?? false) {
        if(payload['type'] == 'new_message'){
          Get.find<RootTabController>().switchTo(2);
          Get.toNamed(Routes.chatView, arguments: {
            'conversation_id': payload['conversation_id']
          });
          print('new message redirectFromNotification');
        }
        else if(payload['type'] == 'profile_view'){
          Get.toNamed(Routes.someOneViewProfile, arguments: {
            'id': payload['sender_id']
          });
          print('new message redirectFromNotification');
        }
      } else {
        print('not logged');
      }
    } catch (e) {
      print('not logged');
    }

    //if (sharedPref.isLoggedIn) {
    // final RedirectData redirectData = RedirectData.fromJson(payload);
    // }
  }
}
