
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/profile_tab/model/help_faq_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportController extends GetxController {

  final sharedPref = SharedPrefHelper();
  // Dynamic grouped data compilation sample array mapping
  final RxList<FAQObjectModel> faqModelList = <FAQObjectModel>[].obs;
  RxInt expandedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize text fields with current dynamic data

    getFAQListApiCall();
  }

  void toggle(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  //TODO: API Implementation
  /// Get FAQ list API call
  Future<void> getFAQListApiCall() async {
    final token = await sharedPref.getAuthToken;

    final response = await BaseApiService().getMethod<FAQListModel>(
      endpoint: Endpoints.faqsList,
      headers: {
        'Authorization': 'Bearer $token'
      },
      showLoader: false,
      fromJson: (json) => FAQListModel.fromJson(json),
    );

    if (response.isSuccess) {
      faqModelList.value = response.data?.data?.faqs ?? [];

    } else if (response.statusCode == 0) {
      InternetDialog.showNoInternetDialog();
    } else {
      print("Error: ${response.message}");
    }
    update();
  }

  Future<void> openEmail({
    required String to,
    String subject = '',
    String body = '',
  }) async {
    final gmailUri = Uri(
      scheme: 'googlegmail',
      host: 'co',
      queryParameters: {
        'to': to,
        'subject': subject,
        'body': body,
      },
    );

    final mailUri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    // Try Gmail first
    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(
        gmailUri,
        mode: LaunchMode.externalApplication,
      );
      return;
    }

    // Fallback to any email app
    if (await canLaunchUrl(mailUri)) {
      await launchUrl(
        mailUri,
        mode: LaunchMode.externalApplication,
      );
      return;
    }

    throw Exception('No email application found.');
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (!await launchUrl(phoneUri)) {
      throw Exception('Could not launch $phoneNumber');
    }
  }

}