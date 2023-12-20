import 'dart:convert';

import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<GeneralResponse2> createCoachReview({
  required String token,
  required playerid,
  required bookingid,
  required rating,
  required bookingtype,
  required attitude,
  required fitness,
  required expression,
  required comment,
  required voicenote,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "playerid": "$playerid",
      "bookingid": "$bookingid",
      "rating": "$rating",
      "bookingtype": "$bookingtype",
      "attitude": "$attitude",
      "fitness": "$fitness",
      "expression": "$expression",
      "comment": "$comment",
      "voicenote": "$voicenote",//TODO ("SET UP VOICE NOTE")
    };

    var url = baseUrl + "api/general/createcoachreview";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return GeneralResponse2.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse2(status: false);
  }
}

Future<GeneralResponse2> createPlayerReview({
  required String token,
  required coachid,
  required bookingid,
  required rating,
  required bookingtype,//bootcam or booking
  required venueRating,
  required startTime,
  required equipmentRating,
  required communicationRating,
  required comment,
  required development,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "coachid": "$coachid",
      "bookingid": "$bookingid",
      "rating": "$rating",
      "bookingtype": "$bookingtype",
      "venueRating": "$venueRating",
      "startTime": "$startTime",
      "equipmentRating": "$equipmentRating",
      "comment": "$comment",
      "communicationRating": "$communicationRating",
      "development": "$development",
    };

    var url = baseUrl + "api/general/createcoachreview";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return GeneralResponse2.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse2(status: false);
  }
}
