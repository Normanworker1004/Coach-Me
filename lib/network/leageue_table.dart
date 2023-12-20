import 'dart:convert';

import 'package:cme/model/coach_leader_board_response.dart';
import 'package:cme/model/player_leaderboard_challenge_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<CoachLeaderBoardResponse> fetchCoachLeaderBoard({
  required String token,
  required isWeekly,
}) async {
  try {
    // print("postFeedback....");

    var map = {"boardtime": "$isWeekly"};

    var url = baseUrl + "api/coach/coachleaderboard";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return CoachLeaderBoardResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return CoachLeaderBoardResponse(status: false);
  }
}

Future<PlayerLeaderBoardResponse> fetchPlayerLeaderBoard({
  required String token,
  required isWeekly,
}) async {
  try {
    print("postFeedback....");

    var map = {"boardtime": "$isWeekly"};

    var url = baseUrl + "api/player/playerleaderboard";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return PlayerLeaderBoardResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return PlayerLeaderBoardResponse(status: false);
  }
}
