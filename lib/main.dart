import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/NotificationService.dart';
import 'package:real_true_date/helper/notification_channel.dart';
import 'package:real_true_date/routes/pages.dart';
import 'routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Set orientation without awaiting if possible
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  _initRevenueCat();

  // 2. Wrap Firebase init in try-catch so network issues don't freeze boot
  try {
    await Firebase.initializeApp();
    await NotificationService().setupInteractedMessage();
    // IOSNotificationChannel.initialize();
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  // 3. Put GetX controller before UI
  Get.put(RootTabController(), permanent: true);

  // 4. Launch UI immediately so Flutter VM handshake completes!
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => const MyApp(),
    ),
  );

  // 5. Run push notification setup IN BACKGROUND after UI mounts
  // _initServicesInBackground();
}

Future<void> _initRevenueCat() async {
  await Purchases.setLogLevel(LogLevel.debug);

  late PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration("goog_YOUR_REVENUECAT_API_KEY");
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration("appl_bozDPzrSzrkyTvMqOWjKBciScCJ");
  }

  await Purchases.configure(configuration);
}

/*Future<void> _initServicesInBackground() async {
  print('_initServicesInBackground');
  // Future.microtask(() async {
    try {
      await NotificationService().setupInteractedMessage();
      debugPrint("Notification service initialized successfully");
    } catch (e) {
      debugPrint("NotificationService setup error: $e");
    }
  // });
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: child!,
          );
        },
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      getPages: AppPages.pages,
    );
  }
}