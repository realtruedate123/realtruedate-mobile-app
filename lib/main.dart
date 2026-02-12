import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:real_true_date/data/root_tab_controller.dart';
import 'package:real_true_date/routes/pages.dart';
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 👈 Must be first line

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  // Root Controller
  Get.put(RootTabController(), permanent: true);

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
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
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      getPages: AppPages.pages,
      // home_tab: BottomNavWrapper(),
    );
  }
}
