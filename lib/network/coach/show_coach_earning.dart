import 'dart:convert';

import 'package:cme/model/coach_earning_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<CoachEarningResponse> fetchCoachEarnings(String token) async {
  try {
    var url = baseUrl + "api/coach/earning";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    return CoachEarningResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print(e);
    return CoachEarningResponse(status: false);
  }
}
