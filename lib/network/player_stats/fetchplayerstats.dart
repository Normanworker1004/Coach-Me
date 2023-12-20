import 'dart:convert';

import 'package:cme/model/fetch_player_stats_response.dart';
import 'package:cme/model/stats_models.dart/create_stats_data.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<FetchPlayerStatsResponse> fetchPlayerStatsData({
  required String token,
}) async {
  try {
    var url = baseUrl + "api/player/fetchplayerstats";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
 print("done PLAYER DATA STAT....${r.body}");
    return FetchPlayerStatsResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print("eror...$e");
    return FetchPlayerStatsResponse(status: false);
  }
}

Future<FetchPlayerStatsResponse> createPlayerPerformanceStats({
  required String token,
  required target,
  required goal,
  required category,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "target": "$target",
      "goal": "$goal",
      "category": "$category",
    };

    var url = baseUrl + "api/player/createperformance";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return FetchPlayerStatsResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchPlayerStatsResponse(status: false);
  }
}

Future<FetchPlayerStatsResponse> updatePlayerPerformanceStats({
  required String token,
  required target,
  required goal,
  required category,
  required statid,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "target": "$target",
      "goal": "$goal",
      "category": "$category",
      "statid": "$statid",
    };
  print("maptosend::::${map}");
    var url = baseUrl + "api/player/editperformance";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return FetchPlayerStatsResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchPlayerStatsResponse(status: false);
  }
}

Future<FetchPlayerStatsResponse> deletePlayerPerformanceStats({
  required String token,
  required statid,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "statid": "$statid",
    };

    var url = baseUrl + "api/player/deleteperformace";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return FetchPlayerStatsResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchPlayerStatsResponse(status: false);
  }
}

Future<CreateStatsDataResponse> addPlayerPerformanceStatsData({
  required String token,
  required statid,
  required data,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "statisticid": "$statid",
      "data": "$data",
    };

    var url = baseUrl + "api/player/createstatisticsdata";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("done....${r.body}");
    return CreateStatsDataResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return CreateStatsDataResponse(status: false);
  }
}
