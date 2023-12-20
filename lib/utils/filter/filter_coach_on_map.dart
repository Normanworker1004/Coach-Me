import 'package:cme/model/coach/diary/coach_diary_data.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../map/calc_distance.dart';

///jsonresponse* must ne in th form jsonDecode(result)
/// 
List<Userdetails> filerCoachOnMapJson({
  required jsonResponse,
  required var sport,
  required var sportLevel,
  required var coachExpertise,
  required var coachGamePlay,
  required var coachPrice,
  required var coachPriceMax,
  var distanceMin = 0 ,
  var distanceMax = 25 ,
  var currentLat,
  var currentLong,
   required var ageGroup,
}) {

  print("called.....");
  var te =
      "$sport,$sportLevel,$coachExpertise,$coachGamePlay,$coachPrice,$ageGroup,";
  print(te);
  var filteredList = [];
  if (jsonResponse["details"] != null) {
    var detailsData = jsonResponse["details"];
    for (var item in detailsData) {
      Userdetails tmpDetails = Userdetails();
      LocationController locationController = Get.find<LocationController>();
      if(locationController.lat.value != 0 || locationController.lng.value != 0){
        tmpDetails.lat = locationController.lat.value;
        tmpDetails.lon =  locationController.lng.value;
      }else{
        tmpDetails.lat = currentLat;
        tmpDetails.lon = currentLong; // fallback.
      }

      if (item["bioinfoforuser"] != null) {
        var biolist = item["bioinfoforuser"];
        for (var bio in biolist) {
          print("my item[bio_lat] ${bio["bio_lat"]}");
          var distance =  calculateDistanceLatLng(tmpDetails, bio["bio_lat"], bio["bio_lon"]);
          print("my current distance is ${distance}");
          print(" $distance < $distanceMax && $distance > $distanceMin ${distance}");
          if ((sport == null || bio["sport"] == sport) &&
              (coachExpertise == null ||
                  bio["bio_expertise"] == coachExpertise) &&
              (coachPrice == null || bio["bio_price"] >= coachPrice) &&
              (coachPriceMax == null || bio["bio_price"] <= coachPriceMax) &&
              (ageGroup == null || bio["bio_age"] == ageGroup) &&
              (sportLevel == null || bio["bio_level"] == sportLevel) &&
              (coachGamePlay == null || bio["bio_gameplay"] == coachGamePlay) &&
              distance < distanceMax && distance > distanceMin
          ) {
            filteredList.add(item);
           }
        }
      }
    }
  }

  print("total found....${filteredList.length}");
  List<Userdetails> us =
      filteredList.map((e) => Userdetails.fromJson(e)).toList();
  return us;
}

List<CoachDiaryData> filerCoachDiaryJson({
  required jsonResponse,
}) {
  print("called.....");

  var filteredList = [];
  if (jsonResponse["details"] != null) {
    var detailsData = jsonResponse["details"];
    for (var item in detailsData) {
      for (var i in item) {
        filteredList.add(i);
      }
    }
  }

  print("total found....${filteredList.length}");
  List<CoachDiaryData> us =
      filteredList.map((e) => CoachDiaryData.fromJson(e)).toList();
  return us;
}
