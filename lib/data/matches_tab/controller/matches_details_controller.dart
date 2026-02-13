import 'package:get/get.dart';

class MatchesDetailsController extends GetxController {

  /// UI State
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }
}
