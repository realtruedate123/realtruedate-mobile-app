import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/utils/singleton.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutController extends GetxController {

  late final WebViewController webViewController;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    webViewLoad();
  }

  void webViewLoad(){
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            isLoading.value = true;
          },
          onPageFinished: (_) {
            isLoading.value = false;
          },
        ),
      )
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(
        Uri.parse(AppURL.aboutUsUrl),
      );
  }

  Future<void> reload() async {
    await webViewController.reload();
  }

  Future<void> goBack() async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
    }
  }

  Future<void> goForward() async {
    if (await webViewController.canGoForward()) {
      await webViewController.goForward();
    }
  }
}