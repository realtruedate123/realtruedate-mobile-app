import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/routes/routes.dart';

bool isExpertAssignedOpened = false;

/// 1️⃣ Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background work
  await Firebase.initializeApp();
  debugPrint("📩 Background message ID: ${message.messageId}");
}

/// 2️⃣ Background notification tap handler
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('🔔 Notification tapped (background): ${notificationResponse.payload}');
}

class NotificationService {
  final sharedPref = SharedPrefHelper();
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Map<String, dynamic>? pendingPayload;

  Future<void> init() async {
    // Request permissions
    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      ).timeout(const Duration(seconds: 5));
      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }

    // iOS native foreground presentation options
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initLocalNotifications();

    isExpertAssignedOpened = false;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // FOREGROUND MESSAGES
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('📩 Foreground message received: ${message.data}');
      // Manually show local notification on iOS and Android to ensure banner appears in foreground
      await showLocalNotification(message);
    });

    // TAP HANDLER: Background/Terminated FCM Native Banner Taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('🔔 FCM Notification tapped: ${message.data}');
      redirectFromNotification(message.data);
    });

    // KILLED STATE TAP
    _checkInitialMessage();

    // Setup Token (Non-blocking)
    _setupFCMToken();
  }

  Future<void> _checkInitialMessage() async {
    try {
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage().timeout(const Duration(seconds: 3));
      if (initialMessage != null) {
        debugPrint('🚀 Initial message found: ${initialMessage.data}');
        pendingPayload = initialMessage.data;
      }
    } catch (e) {
      debugPrint('Error getting initial message: $e');
    }
  }

  static void processPendingNotification() {
    if (pendingPayload != null) {
      debugPrint('Processing pending notification...');
      redirectFromNotification(pendingPayload!);
      pendingPayload = null;
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if ((details.payload ?? '').isNotEmpty) {
          try {
            final payload = json.decode(details.payload!);
            redirectFromNotification(payload);
          } catch (e) {
            debugPrint('Error decoding notification payload: $e');
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

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

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
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

  void _setupFCMToken() {
    if (Platform.isIOS) {
       _getAPNSTokenAndThenFCMToken();
    } else {
      _fetchAndSaveToken();
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FIREBASE REFRESH TOKEN: $newToken');
      sharedPref.saveFirebaseToken(newToken);
    });
  }

  void _getAPNSTokenAndThenFCMToken() async {
    int retries = 0;
    String? apnsToken;
    while (apnsToken == null && retries < 5) {
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 2));
        retries++;
      }
    }
    _fetchAndSaveToken();
  }

  void _fetchAndSaveToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('FIREBASE TOKEN: $token');
      if (token != null) sharedPref.saveFirebaseToken(token);
    }).catchError((e) {
      debugPrint('Error getting FCM token: $e');
    });
  }

  static void redirectFromNotification(Map<String, dynamic> payload) {
    debugPrint('🚀 Redirecting from payload: $payload');
    if (payload['type'] == 'new_message') {
       try {
         Get.find<RootTabController>().switchTo(2);
         Get.toNamed(Routes.chatView, arguments: {
           'conversation_id': payload['conversation_id']
         });
       } catch (e) {
         debugPrint('Navigation error: $e. Storing as pending.');
         pendingPayload = payload;
       }
    }
  }
}
