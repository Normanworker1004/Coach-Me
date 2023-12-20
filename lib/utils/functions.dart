import 'package:cme/map/calc_distance.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/coach/request.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/app.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/location_controller.dart';

String getCoachSportLevel(Userdetails d, {String sport: "football"}) {
  try {
    List<BNBItem> cLevel = [
      BNBItem("Expert", "assets/badge4.png"),
      BNBItem("Professional", "assets/badge3.png"),
      BNBItem("Grassroot", "assets/badge2.png"),
      BNBItem("Amater", "assets/badge1.png"),
    ];
    var indexOfLevel = 0;
    if (d.sport == null) {
      indexOfLevel = 0;
    } else {
      if (d.sport!.level == null) {
        indexOfLevel = 0;
      } else {
        var s = d.sport!;
        for (var k = 0; k < s.sport!.length; k++) {
          if ("${s.sport![k]}" == sport) {
            indexOfLevel = s.level![k];
            // print("...at $k");
            break;
          }
        }
      }
    }

    return cLevel[indexOfLevel].title;
  } catch (e) {
    return "Expert";
  }
}

String calculateDistanceBtw(Userdetails player1, Userdetails player2) {
  try {
    print("calculating distance...");
    var lat1 = (player1.lat ?? 51.5074) / 1.0;
    var lng1 = (player1.lon ?? 51.5074) / 1.0;

    var lat2 = (player2.lat ?? 51.5074) / 1.0;
    var lng2 = (player2.lon ?? 51.5074) / 1.0;

    var distance = distanceBTWLatLng(lat1, lng1, lat2, lng2);

    return "${(distance).toStringAsFixed(1)} km";
  } catch (e) {
    print("Errorr...calculating distance...");
    return "1000 km";
  }
}

double calculateDistance(Userdetails player1, Userdetails player2) {
  try {
    var lat1 = (player1.lat ?? 51.5074) / 1.0;
    var lng1 = (player1.lon ?? 51.5074) / 1.0;

    var lat2 = (player2.lat ?? 51.5074) / 1.0;
    var lng2 = (player2.lon ?? 51.5074) / 1.0;

    return distanceBTWLatLng(lat1, lng1, lat2, lng2);
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

Widget buildCoachSearchItem(Userdetails u, Userdetails currentDetails,
    {sport: "football"}) {
  LocationController locationController = Get.find<LocationController>();

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          CircularNetworkImage(
            imageUrl: "${photoUrl + u.profilePic!}",
            size: 48,
          ),
          horizontalSpace(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText("${u.name}", size: 14),
              verticalSpace(height: 4),
              mediumText("${getCoachSportLevel(u, sport: sport)}", size: 12),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: red, size: 12),
                      horizontalSpace(width: 4),
                      mediumText(
                          "${(u.profile?.rating ?? 0).toStringAsFixed(1)}",
                          color: red,
                          size: 12),
                    ],
                  ),
                  horizontalSpace(),
                  lightText(
                    "${calculateDistanceLatLng(u,locationController.lat.value  ,locationController.lng.value).toStringAsFixed(2)}km away",
                  ),
                ],
              ),
            ],
          ))
        ]),
      ),
      Divider(),
    ],
  );
}

List<Widget> markerBootCampWidgets(List<BootCampDetails> bootCampLis) {
  var l = bootCampLis;
  return List.generate(
    l.length,
    (index) {
      return CircularImage(
        imageUrl: "assets/boot_icon.png",
        size: 48,
      );
    },
  );
}

List<Widget> markerCoachWidgets(List<Userdetails> details) {
  var l = details;

  return List.generate(
    l.length,
    (index) {
      var i = l[index];
      var url = "${l[index].profilePic!}";
      return Container(
        height: 64,
        width: 64,
        child: Stack(
          children: <Widget>[
            CircularNetworkImage(
              imageUrl: url,
              size: 58,
            ),
            Positioned(
              // top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Color.fromRGBO(182, 9, 27, 1),
                      size: 14,
                    ),
                    horizontalSpace(),
                    Text(
                      "${((i.profile?.rating ?? 1)  / 1.0).toStringAsFixed(1)}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
