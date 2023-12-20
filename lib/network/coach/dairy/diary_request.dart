import 'dart:convert';

import 'package:cme/model/coach/diary/fetch_diary_unavailability_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<FetchDiaryUnAvailabilityResponse> fetchCoachDairyUnavailability(
    String token) async {
  try {
    var url = baseUrl + "api/bio/fetch_unavailibility";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );

    return FetchDiaryUnAvailabilityResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print(e);
    return FetchDiaryUnAvailabilityResponse(status: false);
  }
}

Future<FetchDiaryUnAvailabilityResponse> addCoachDairyUnavailability(
  String token, {
  required booking,
  required bookingid,
  required unavailablestart,
  required unavailableend,
  required availableType,
  required timingstart,
  required timingend,
}) async {
  try {
    var map = {
      "booking": "$booking",
      "bookingid": "$bookingid",
      "unavailablestart": "$unavailablestart",
      "unavailableend": "$unavailableend",
      "available_type": "$availableType",
      "timingstart": "$timingstart",
      "timingend": "$timingend",
    };
    print(map);
    var url = baseUrl + "api/bio/diary";
    http.Response r = await http.post(
      Uri.parse(url),
      body: map,
      headers: {
        "x-access-token": token,
      },
    ).catchError((e) {
      print("erro........$e");
    });
    print("response....${r.body}");
    return FetchDiaryUnAvailabilityResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print(e);
    print("erro...tht.....$e");
    return FetchDiaryUnAvailabilityResponse(status: false);
  }
}

Future<GeneralResponse2> editCoachDairyUnavailability(
  String token, {
  required booking,
  required bookingid,
  required unavailablestart,
  required unavailableend,
  required availableType,
  required timingstart,
  required timingend,
  required unavailibilityID,
}) async {
  try {
    var map = {
      "booking": "$booking",
      "bookingid": "$bookingid",
      "unavailablestart": "$unavailablestart",
      "unavailableend": "$unavailableend",
      "available_type": "$availableType",
      "timingstart": "$timingstart",
      "timingend": "$timingend",
      "unavailibilityID": "$unavailibilityID",
    };
    print(map);
    var url = baseUrl + "api/bio/edit_unavailibility";
    http.Response r = await http.post(
      Uri.parse(url),
      body: map,
      headers: {
        "x-access-token": token,
      },
    ).catchError((e) {
      print("erro........$e");
    });
    print("response....${r.body}");
    return GeneralResponse2.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print(e);
    print("erro...tht.....$e");
    return GeneralResponse2(status: false);
  }
}

Future<GeneralResponse2> deleteCoachDairyUnavailability(
  String token, {
  required bookingid,
}) async {
  try {
    var map = {
      "unavailibilityID": "$bookingid",
    };
    print(map);
    var url = baseUrl + "api/bio/delete_unavailibility";
    http.Response r = await http.post(
      Uri.parse(url),
      body: map,
      headers: {
        "x-access-token": token,
      },
    ).catchError((e) {
      print("erro........$e");
    });
    print("response....${r.body}");
    return GeneralResponse2.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print(e);
    print("erro...tht.....$e");
    return GeneralResponse2(status: false);
  }
}

Future fetchMothCoachDairyUnavailability(
  String token, {
  required date,
}) async {
  try {
    var map = {
      "unavailablestart": "$date",
    };
    print(map);
    var url = baseUrl + "api/bio/fetchunavailable";
    http.Response r = await http.post(
      Uri.parse(url),
      body: map,
      headers: {
        "x-access-token": token,
      },
    ).catchError((e) {
      print("erro........$e");
    });

    return jsonDecode(r.body);
  } catch (e) {
    // print(e);
    print("erro...tht.....$e");
    return null;
  }
}

Future fetchMothCoachDairyUnavailabilityById(
  String token, {
  required date,
  required coachId,
}) async {
  try {
    var map = {
      "unavailablestart": "$date",
      "coachid": "$coachId",
    };
    print(map);
    var url = baseUrl + "api/bio/fecthcoachuaviablity";
    http.Response r = await http.post(
      Uri.parse(url),
      body: map,
      headers: {
        "x-access-token": token,
      },
    ).catchError((e) {
      print("erro........$e");
    });

    return jsonDecode(r.body);
  } catch (e) {
    // print(e);
    print("erro...tht.....$e");
    return null;
  }
}
