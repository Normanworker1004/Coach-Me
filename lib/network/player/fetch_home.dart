import 'dart:convert';

import 'package:cme/model/fetch_player_home_booking_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<FetchPlayerHomeBookingResponse> fetchPlayerHomeBooking(
    token,
    ) async {
  try {
    print("fetch home....");
    var url = baseUrl + "api/player/fetch_home_booking";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
    );
    print("fetch home stats...." + r.body);
    var v = FetchPlayerHomeBookingResponse.fromJson(jsonDecode(r.body));
    print(v.status);
    return v;
  } catch (e) {
    print(e);
    return FetchPlayerHomeBookingResponse(
        status: false, message: "Error occured");
  }
}
