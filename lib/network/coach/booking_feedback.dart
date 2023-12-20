import 'dart:convert';

import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<GeneralResponse2> cocahCreateIAP(
  token, {
  required playerid,
  required ballcontrol,
  required differentSurface,
  required possession,
  required positioning,
  required movement,
  required passing,
  required cordination,
  required balance,
  required note,
}) async {
  try {
    print("approve");
    var map = {
      "playerid": "$playerid",
      "ballcontrol": "$ballcontrol",
      "differentSurface": "$differentSurface",
      "possession": "$possession",
      "positioning": "$positioning",
      "movement": "$movement",
      "passing": "$passing",
      "cordination": "$cordination",
      "balance": "$balance",
      "note": "$note",
    };
    var url = baseUrl + "api/coach/createiap";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    print("error....$e");
    return GeneralResponse2(status: false, message: "Error Occured");
  }
}

Future<GeneralResponse2> sendPlayerBookingFeedback(
  token, {
  required coachid,
  required bookingid,
  required rating,
  required bookingtype,
  required venueRating,
  required startTime,
  required equipmentRating,
  required communicationRating,
  required comment,
  required development,
}) async {
  try {
    print("approve");
    var map = {
      "coachid": "$coachid",
      "bookingid": "$bookingid",
      "rating": "$rating",
      "bookingtype": "$bookingtype",
      "venueRating": "$venueRating",
      "startTime": "$startTime",
      "equipmentRating": "$equipmentRating",
      "communicationRating": "$communicationRating",
      "comment": "$comment",
      "development": "$development",
    };
    var url = baseUrl + "api/general/createreview";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    print("error....$e");
    return GeneralResponse2(status: false, message: "Error Occured");
  }
}
