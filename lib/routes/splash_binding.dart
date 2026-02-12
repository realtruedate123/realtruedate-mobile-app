import 'package:get/get.dart';
import 'package:real_true_date/data/splash_on_boarding%20/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
