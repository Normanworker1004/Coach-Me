
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String?> convertCordinaeToAddress(LatLng location) async {
  try {

    var placemarks =  await placemarkFromCoordinates(location.latitude, location.longitude);

    // print("address....${jsonEncode(addresses)}");
    var first = placemarks.first;
    // print("${first.featureName} : ${first.addressLine}");
    return first.name;
  } catch (e) {
    // print("convertError....$e");
    return "Unknown";
  }
}
