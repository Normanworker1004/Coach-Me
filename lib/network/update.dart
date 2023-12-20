import 'dart:convert';

import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<GeneralResponse2> updateUserLoactionOnServer({
  required String token,
  required location,
  required lon,
  required lat,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "location": "$location",
      "lon": "$lon",
      "lat": "$lat",
    };

    var url = baseUrl + "api/general/updateprofilelocation";
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

Future<GeneralResponse2> updateProfileSport({
  required String token,
  required List sports,
  required List experienceLevel,
}) async {
  try {
    // print("postFeedback....");

    var mp = jsonEncode({"sport": sports, "level": experienceLevel});
    var map = {"sport": mp};

    var url = baseUrl + "api/general/updateprofilesport";
    print("on URL : ${url}");
    print("${map}");


    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return GeneralResponse2.fromJson(jsonDecode(r.body));
  } catch (e) {
    print("erroooor...$e");
    return GeneralResponse2(status: false);
  }
}
