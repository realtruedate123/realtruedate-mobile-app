import 'package:get/get.dart';
import 'package:real_true_date/data/matches_tab/controller/matches_tab_controller.dart';
import 'package:real_true_date/data/profile_tab/model/saved_profile_model.dart';

class SavedProfileController extends GetxController{
  /// UI State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Button enable state
  final isLoginEnabled = false.obs;

  final List<SavedProfileModel> matches = [
    SavedProfileModel(
      name: "Clyra Monica",
      age: 21,
      location: "Prague, Czech Republic",
      imageUrl:
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
      matchPercent: 90,
      isVerified: true,
    ),
    SavedProfileModel(
      name: "Maria Icabes",
      age: 22,
      location: "Panay, Philippines",
      imageUrl:
      "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
      matchPercent: 80,
      isVerified: true,
    ),
    SavedProfileModel(
      name: "Tukiyem Anes",
      age: 23,
      location: "Paris, France",
      imageUrl:
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
      matchPercent: 70,
      isVerified: true,
    ),
    SavedProfileModel(
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
  }

  @override
  void onClose() {
    super.onClose();
  }

}