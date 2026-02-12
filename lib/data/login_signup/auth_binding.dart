import 'package:get/get.dart';
import 'package:real_true_date/data/login_signup/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
