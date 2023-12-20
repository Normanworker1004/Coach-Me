import 'dart:convert';

import 'package:cme/model/buddy_up_response.dart';
import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future fetchMapCoachDetails(token) async {
  try {
    var url = baseUrl + "api/player/coach_and_bootcamp";
    // print(token);

    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        // "Accept": "application/json",
      },
    );
    return jsonDecode(r.body);
  } catch (e) {
    return {"status": false};
  }
}

Future<MapBootCampResponse> fetchBootCampOnly(token) async {
  try {
    // print("fetch bio");
    var url = baseUrl + "api/player/bootcamp_only";
    // print(url);

    // print(token);

    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        // "Accept": "application/json",
      },
    );

    // print(r.body);
    // print(jsonDecode(r.body)['Profile']);
    var re = MapBootCampResponse.fromJson(jsonDecode(r.body));

    // print("status: ${re.details.length}++++++++++");
    return re;
  } catch (e) {
    print("Error.....$e");
    return MapBootCampResponse(status: false);
  }
}

Future<BuddyUpResponse> fetchBuddyUpPlayers(token) async {
  try {
    var url = baseUrl + "api/buddyup/fetchplayer";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    var re = BuddyUpResponse.fromJson(jsonDecode(r.body));
    // print("total: ${re.playerDetails.length}players");
    return re;
  } catch (e) {
    // print("Error.....$e");
    return BuddyUpResponse(status: false);
  }
}
