import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/helper/notification_service.dart';
import 'package:real_true_date/routes/pages.dart';
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 👈 Must be first line
  // await SharedPrefHelper.init();
  // Lock orientation to portrait only

  // await SharedPreferences.getInstance(); // Initialize early

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  await Firebase.initializeApp();
  await NotificationService().setupInteractedMessage();

  /*
  // Internet
  ConnectivityService(); // initialize once
  // Start listening globally
  ConnectivityService().stream.listen((status) {
    if (status.contains(ConnectivityResult.none)) {
      debugPrint("🔴 No Internet");
      InternetDialog.showNoInternetDialog();   // 👈 call wrapper
    } else {
      debugPrint("🟢 Connected: $status");
    }
  });*/

  // Root Controller
  Get.put(RootTabController(), permanent: true);

  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      // minTextAdapt: true,
      // splitScreenMode: true,
      // useInheritedMediaQuery: true,
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: EasyLoading.init(),
      // builder: (context, child) {
      //   child = EasyLoading.init()(context, child);
      //   return child;
      // },
      // UPDATED: Wrap child with MediaQuery to fix font size globally
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling, // Forces text scale factor to 1.0 everywhere
            ),
            child: child!,
          );
        },
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      getPages: AppPages.pages,
      // home_tab: BottomNavWrapper(),
    );
  }
}
