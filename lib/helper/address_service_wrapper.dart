import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:real_true_date/helper/common_model.dart';

class AddressServiceWrapper {
  // Reactive values so UI can listen easily (optional)
  final RxBool isLoadingAddress = false.obs;
  final RxString currentAddress = ''.obs;

  UserLocationAddressModel? addressModel;
  // final Geocoding geocoding = Geocoding();

  /// Fetch address details from latitude and longitude
  Future<UserLocationAddressModel?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      isLoadingAddress.value = true;
      currentAddress.value = "Fetching address...";

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        currentAddress.value =
        "${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}, "
            "${p.administrativeArea ?? ''}, ${p.postalCode ?? ''}";

        // Debug info
        debugPrint('street: ${p.street}');
        debugPrint('locality: ${p.locality}');
        debugPrint('administrativeArea: ${p.administrativeArea}');
        debugPrint('country: ${p.country}');
        debugPrint('subLocality: ${p.subLocality}');
        debugPrint('postalCode: ${p.postalCode}');

        addressModel = UserLocationAddressModel(
          streetName: p.street,
          areName: p.subLocality,
          cityName: p.locality,
          stateName: p.administrativeArea,
          postalCode: p.postalCode,
          country: p.country,
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        currentAddress.value = "No address found";
        addressModel = null;
      }
    } catch (e) {
      debugPrint('Error in getAddressFromLatLng: $e');
      currentAddress.value = "Error fetching address";
      addressModel = null;
    } finally {
      isLoadingAddress.value = false;
    }

    return addressModel;
  }
}
