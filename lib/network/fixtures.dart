import 'dart:convert';

import 'package:cme/model/fetch_fixtures_leaderboard_response.dart';
import 'package:cme/network/coach/request.dart';

import 'package:http/http.dart' as http;

Future<FetchFixturesLeaderBoardResponse> fetchFixturesLeaderBoard({
  required String token,
}) async {
  try {
    var url = baseUrl + "api/fixture/fixtureleaderboard";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    print(r.body);
    return FetchFixturesLeaderBoardResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchFixturesLeaderBoardResponse(status: false);
  }
}
