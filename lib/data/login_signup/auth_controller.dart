import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/core/utils/platform_util.dart';
import 'package:real_true_date/data/login_signup/model/login_model.dart';
import 'package:real_true_date/data/login_signup/model/register_model.dart';
import 'package:real_true_date/helper/bottom_nav_wrapper.dart';
import 'package:real_true_date/helper/string_class.dart';
import 'package:real_true_date/routes/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthTab { signup, login }
enum SignupStep { step1, step2 }

class AuthController extends GetxController {
  /// UI State
  final currentTab = AuthTab.signup.obs;
  final signupStep = SignupStep.step1.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final errorMessageStepTwo = ''.obs;
  RxBool agreeTC = false.obs;
  RxBool isChecked = false.obs;
  RxBool isFormValid = false.obs;
  RxBool isSecondFormValid = false.obs;
  RxString selectedGender = 'Male'.obs;

  /// FORM KEYS
  final signupStepOneKey = GlobalKey<FormState>();
  final signupStepTwoKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();

  /// CONTROLLERS
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final singUpEmailCtrl = TextEditingController();
  final singUpPasswordCtrl = TextEditingController();

  RxnString lookingGender = RxnString();
  Rxn<DateTime> dob = Rxn<DateTime>();
  final sharedPref = SharedPrefHelper();

  /// Button enable state
  final isLoginEnabled = false.obs;

  final emailError = RxnString();
  final passwordError = RxnString();

  final signUpEmailError = RxnString();
  final signUpPasswordError = RxnString();

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  void onInit() {
    super.onInit();

    // emailCtrl.text = 'm7@yopmail.com';
    // passwordCtrl.text = 'J@123456';

    emailCtrl.addListener(_checkLoginEnable);
    passwordCtrl.addListener(_checkLoginEnable);
    zipCtrl.addListener(_validateForm);

    nameCtrl.addListener(_validateTwoForm);
    singUpEmailCtrl.addListener(_validateTwoForm);
    singUpPasswordCtrl.addListener(_validateTwoForm);

    /// Listen to changes
    everAll(
      [lookingGender, dob, isChecked],
          (_) => _validateForm(),
    );

    everAll(
      [selectedGender],
          (_) => _validateTwoForm(),
    );

    /// Selected form type
    if(Get.arguments != null) {
      currentTab.value = Get.arguments;
    }
  }

  // @override
  // void onClose() {
  //   emailCtrl.dispose();
  //   passwordCtrl.dispose();
  //
  //   lookingGender.value = '';
  //   zipCtrl.dispose();
  //   dobCtrl.dispose();
  //   nameCtrl.dispose();
  //   singUpEmailCtrl.dispose();
  //   singUpPasswordCtrl.dispose();
  //   selectedGender.value = '';
  //
  //   super.onClose();
  // }

  void _checkLoginEnable() {
    isLoginEnabled.value =
        emailCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty;
  }

  /// ======================== START ==========================

  void clearEmailError() {
    if (emailError.value != null) {
      emailError.value = null;
    }
  }

  void clearPasswordError() {
    if (passwordError.value != null) {
      passwordError.value = null;
    }
  }

  /// ======================== END ==========================

  /// Login api call
  Future<void> login() async {
    // Get.offAll(() => BottomNavWrapper());

    emailError.value = null;
    passwordError.value = null;
    errorMessage.value = '';

    if(validateEmail(emailCtrl.text) == false){
      emailError.value = 'Enter a valid email address';
      isLoading.value = false;
      return;
    }
    if (passwordCtrl.text.length < 8) {
      passwordError.value = 'This password is too short. It must contain at least 8 characters.';
      return;
    }
    if (!loginKey.currentState!.validate()) return;

    isLoading.value = true;
    userLoginApiCall();
  }

  void nextSignupStep() {
    if (signupStepOneKey.currentState!.validate()) {
      signupStep.value = SignupStep.step2;
    }
  }

  /// Register api call
  Future<void> submitSignup() async {
    signUpEmailError.value = null;
    signUpPasswordError.value = null;
    errorMessageStepTwo.value = '';

    if(validateEmail(singUpEmailCtrl.text) == false){
      print('signup step two');
      signUpEmailError.value = 'Enter a valid email address';
      isLoading.value = false;
      return;
    }
    if (singUpPasswordCtrl.text.length < 8) {
      signUpPasswordError.value = 'This password is too short. It must contain at least 8 characters.';
      return;
    }

    // if (!signupStepTwoKey.currentState!.validate()) return;

    isLoading.value = true;
    userRegisterApiCall();
  }

  void switchTab(AuthTab tab) {
    currentTab.value = tab;
    signupStep.value = SignupStep.step1;
    errorMessage.value = '';
  }

  /// SignUp Step One FORM VALIDATION
  void _validateForm() {
    // isFormValid.value =
    //     lookingGender.value != null &&
    //         zipCtrl.text.trim().isNotEmpty &&
    //         dob.value != null &&
    //         isChecked.value;


    isFormValid.value =
        nameCtrl.text.trim().isNotEmpty &&
            dob.value != null &&
            singUpEmailCtrl.text.trim().isNotEmpty &&
            lookingGender.value != null &&
            singUpPasswordCtrl.text.trim().isNotEmpty &&
            selectedGender.isNotEmpty &&
            isChecked.value;
  }

  void toggleTC(bool value) {
    agreeTC.value = value;
    isChecked.value = value;
    _validateForm();
  }

  void setLookingGender(String value) {
    lookingGender.value = value;
    _validateForm();
  }

  void setDob(DateTime value) {
    dob.value = value;
    _validateForm();
  }

  /// SignUp Step Two FORM VALIDATION
  void _validateTwoForm() {
    isSecondFormValid.value =
        nameCtrl.text.trim().isNotEmpty &&
            singUpEmailCtrl.text.trim().isNotEmpty &&
            singUpPasswordCtrl.text.trim().isNotEmpty &&
            selectedGender.isNotEmpty;
  }

  void setGender(String value) {
    selectedGender.value = value;
    _validateTwoForm();
  }

  //TODO: Signup API Call
  Future<void> userRegisterApiCall() async {
    final deviceId = await DeviceUtils.getDeviceUDID();

    final dateConvert = DateFormat('yyyy-MM-dd').format(dob.value!);

    final params = {
      "email": singUpEmailCtrl.text,
      "password": singUpPasswordCtrl.text,
      "full_name": nameCtrl.text,
      "gender": selectedGender.value.toString()[0],  // for male : M , female : F, other : O
      "looking_for": lookingGender.value.toString()[0], // for male : M , female : F, other : O
      "date_of_birth": dateConvert, //yyyy-mm-dd
      "zip_code": zipCtrl.text,
      "device_id": deviceId,
      "fcm_token": '',
      "device_type": PlatformUtil.getPlatformName().toString()
    };

    print('params $params');

    final response = await BaseApiService().postRawData<RegisterResponseModel>(
      endpoint: Endpoints.userRegister,
      fields: params,
      fromJson: (json) => RegisterResponseModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      singUpEmailCtrl.text = '';
      singUpPasswordCtrl.text = '';
      nameCtrl.text = '';
      zipCtrl.text = '';
      lookingGender.value = '';

      /// Checked profile verify or not
      if(response.data?.data?.tokens != null){
        await Future.wait([
          sharedPref.saveRefreshAuthToken(response.data?.data?.tokens?.refresh ?? ''),
          sharedPref.saveAuthToken(response.data?.data?.tokens?.access ?? '')
        ]);
        await Future.delayed(const Duration(seconds: 1));
        /// Checked video upload or not
        if(response.data?.data?.verificationStatus?.videoVerified == false){
          Get.toNamed(Routes.uploadVideoPage);
        }
        /// Checked photo upload or not
        else if(response.data?.data?.verificationStatus?.photoVerified == false){
          Get.toNamed(Routes.uploadPhotoPage);
        }
        /// Checked dream data profile complete or not
        else if(response.data?.data?.verificationStatus?.hasDreamDateProfile == false){
          Get.toNamed(Routes.selectDreamPartnerView);
        }
        else {
          // Get.toNamed(Routes.profileUnderReviewScreen);
        }
      } else { /// New user register
        Get.toNamed(
            Routes.otpScreen,
            arguments: {
              'email': response.data?.data?.email ?? '',
              'otp': response.data?.data?.otp.toString()
            }
        );
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessageStepTwo.value = response.message ?? 'Registration failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }

  //TODO: Login API Call
  Future<void> userLoginApiCall() async {
    final deviceId = await DeviceUtils.getDeviceUDID();

    final params = {
      "email": emailCtrl.text,
      "password": passwordCtrl.text,
      "device_id": deviceId,
      "fcm_token": '',
      "device_type": PlatformUtil.getPlatformName().toString()
    };

    print('params $params');

    final response = await BaseApiService().postRawData<LoginModel>(
      endpoint: Endpoints.userLogin,
      fields: params,
      fromJson: (json) => LoginModel.fromJson(json),
    );
    isLoading.value = false;

    if (response.isSuccess && response.statusCode == 200) {
      emailCtrl.text = '';
      passwordCtrl.text = '';

      /// Checked profile verify or not
      await Future.wait([
        sharedPref.saveRefreshAuthToken(response.data?.data?.tokens?.refresh ?? ''),
        sharedPref.saveAuthToken(response.data?.data?.tokens?.access ?? '')
      ]);

      /// Checked video upload or not
      if(response.data?.data?.verificationStatus?.videoVerified == false){
        Get.toNamed(Routes.uploadVideoPage);
      }
      /// Checked photo upload or not
      else if(response.data?.data?.verificationStatus?.photoVerified == false){
        await Future.wait([
          sharedPref.saveVideoVerificationFlag(response.data?.data?.verificationStatus?.videoVerified ?? false),
        ]);
        Get.toNamed(Routes.uploadPhotoPage);
      }
      /// Checked dream data profile complete or not
      else if(response.data?.data?.verificationStatus?.hasDreamDateProfile == false){
        Get.toNamed(Routes.selectDreamPartnerView);
      }
      else { /// Login User
        await Future.wait([
          sharedPref.saveIsLoggedIn(true),
          sharedPref.savePersonList(response.data!.data!),
          sharedPref.saveUserId(response.data?.data?.user?.id ?? '')
        ]);

        Get.offAll(() => BottomNavWrapper());
      }
    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      errorMessage.value = response.message ?? 'Login failed';
      // Get.snackbar('Failed', response.message ?? 'Registration failed');
    }
  }
}
