import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/login_signup/model/register_model.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';

class MatchesTabController extends GetxController {

  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// CONTROLLERS
  final emailCtrl = TextEditingController();

  /// Button enable state
  final isLoginEnabled = false.obs;

  final List<MatchModel> matches = [
    MatchModel(
      name: "Clyra Monica",
      age: 21,
      location: "Prague, Czech Republic",
      imageUrl:
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
      matchPercent: 90,
      isVerified: true,
    ),
    MatchModel(
      name: "Maria Icabes",
      age: 22,
      location: "Panay, Philippines",
      imageUrl:
      "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
      matchPercent: 80,
      isVerified: true,
    ),
    MatchModel(
      name: "Tukiyem Anes",
      age: 23,
      location: "Paris, France",
      imageUrl:
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
      matchPercent: 70,
      isVerified: true,
    ),
    MatchModel(
      name: "Oktavia Caca",
      age: 24,
      location: "Wilkesy, Poland",
      imageUrl:
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb",
      matchPercent: 60,
      isVerified: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();

    emailCtrl.addListener(_checkLoginEnable);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    super.onClose();
  }

  void _checkLoginEnable() {
    isLoginEnabled.value = emailCtrl.text.isNotEmpty;
  }

  void forgotPassword(){
    if(validateEmail(emailCtrl.text) == false){
      print('login');
      errorMessage.value = 'Enter a valid email address';
      isLoading.value = false;
      return;
    }
    else{
      print('$emailCtrl.text');
      errorMessage.value = '';
      forgotPasswordApiCall();
    }
  }

  //TODO: Forgot password API Call
  Future<void> forgotPasswordApiCall() async {

    final params = {
      "email": emailCtrl.text,
    };

    print('params $params');

    final response = await BaseApiService().postRawData<RegisterResponseModel>(
      endpoint: Endpoints.forgotPassword,
      fields: params,
      fromJson: (json) => RegisterResponseModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {

      Get.toNamed(
          Routes.otpScreen,
          arguments: {
            'email': response.data?.data?.email ?? '',
            'otp': response.data?.data?.otp.toString(),
            'page_type': 'forgot_screen'
          }
      );
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'Something went wrong';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }
}

class MatchModel {
  final String name;
  final int age;
  final String location;
  final String imageUrl;
  final int matchPercent;
  final bool isVerified;

  MatchModel({
    required this.name,
    required this.age,
    required this.location,
    required this.imageUrl,
    required this.matchPercent,
    this.isVerified = false,
  });
}