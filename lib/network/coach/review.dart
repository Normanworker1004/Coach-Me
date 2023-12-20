import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future addCoachReview(
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

    // print("Saving........$map");
    var url = "${baseUrl}api/general/createreview";
    http.Response r = await http.post(
      Uri.parse(url),
      // baseUrl + "api/general/createreview",
      headers: {"x-access-token": token},
      body: map,
    );
    // print("Saving.......+=++++.");
    var j = jsonDecode(r.body);
    return j["message"];
  } catch (e) {}
}
