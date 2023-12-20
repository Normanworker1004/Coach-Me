import 'package:geolocator/geolocator.dart';

import '../model/user_class/user_details.dart';

double distanceBTWLatLng(lat, lng, lat2, lng2) {
  try {
    return Geolocator.distanceBetween(lat, lng, lat2, lng2)/1000 * .61;
  } catch (e) {
    print("Errorr...calculating distance...");
    return 2000.0;
  }
}

double calculateDistanceLatLng(Userdetails player1, lat, lng) {
  try {
    print("calculating distance...");

    var lat1 = (player1.lat ?? 51.5074) / 1.0;
    var lng1 = (player1.lon ?? 51.5074) / 1.0;

    var lat2 = (lat ?? 51.5074) / 1.0;
    var lng2 = (lng ?? 51.5074) / 1.0;

    return distanceBTWLatLng(lat1, lng1, lat2, lng2);
  } catch (e) {
    print("Errorr...calculating distance...");
    return 2000.0;
  }
}
