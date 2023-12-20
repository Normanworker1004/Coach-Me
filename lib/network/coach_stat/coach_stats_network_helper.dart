import 'dart:convert';
import 'dart:developer';
import 'package:cme/network/coach/request.dart';
import 'package:cme/network/coach_stat/coach_stats_data.dart';
import 'package:http/http.dart' as http;

Future<CoachStatisticsData> fetchCoachStats(token) async {
  try {
    // print("fetch bio");
    var url = baseUrl + "api/coach/coachstat";
    // print(url);

    // print(token);

    http.Response r = await http.get(
      Uri.parse(url),
      headers: {"x-access-token": token, "Accept": "application/json"},
    );

    // print(jsonDecode(r.body)['Profile']);
    return CoachStatisticsData.fromJson(jsonDecode(r.body));
  } catch (e) {
    log(
      'An Error occurred while trying to fetch coach Stats',
      level: 3,
      error: e,
    );
    print('An Error occurred while trying to fetch coach Stats $e');
    return CoachStatisticsData(status: false);
  }
}

Future<Map<String, dynamic>?> updateTarget(
    token,  type, double value) async {
  try {
    var map = {
      "target_type": type.toString().replaceFirst('TargetType.', ''),
      "target": "$value",
    };
    var url = baseUrl + "api/coach/updatetarget";

    // print(token);
    http.Response r = await http
        .post(
      Uri.parse(url),
          headers: {
            "x-access-token": token,
          },
          body: map,
        )
        .whenComplete(() => () {
              print("Updated Successfully!");
            })
        .catchError((error) {
      print("An Error Occurred");
      print(error);
    });

    print("Updated Successfully!");
    print(r.body);
    return jsonDecode(r.body);
    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    print('An Error Occurred!');
    // return BioResponse(status: false);
    print(e);
    return null;
  }
}

enum TargetType {
  target_session,
  target_hour,
  target_earning,
  target_train_hr,
  target_weight,
  target_goal_scored,
  target_squats,
  target_other
}
