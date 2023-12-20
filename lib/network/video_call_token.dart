import 'dart:convert';

import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

String challengeEvent = "challenge";
String buddyUpEvent = "buddyup";
String bookingEvent = "booking";

String eventStarted = "STARTED";
String eventCompleted = "COMPLETED";

Future<String?> genrateVideoToken(token, {String? channelName, bool isMainUser = false}) async {
  try {
    var map = {
       "title": channelName,
     };
   // String? tokenVideo = null; // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
    var url = baseUrl + "api/booking/";

    if(isMainUser) url = url + "generatevideotoken_uid";
    else url = url + "generatevideotoken_viewer";

    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    print("map  ....${map}");

    var resp = GeneralResponse.fromJson(jsonDecode(r.body));
    print("token res....${resp.message}");
    return resp.message;
  } catch (e) {
    return "";
  }
}

Future<GeneralResponse> startVirtualChallenge(
  token, {
  required String videoToken,
  required String challengeId,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "virtualstatus": "STARTED",
      "challengeid": challengeId,
      "videotoken": videoToken,
    };

    var url = baseUrl + "api/challenge/startvirtualchallenge";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    // print("done....${r.body}");
    return GeneralResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> endVirtualChallenge(
  token, {
  required String challengeId,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "virtualstatus": "COMPLETED",
      "challengeid": challengeId,
    };

    var url = baseUrl + "api/challenge/endvirtualchallenge";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    return GeneralResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> startVirtualBuddyUp(
  token, {
  required String videoToken,
  required String buddyUpId,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "virtualstatus": "STARTED",
      "buddyupid": buddyUpId,
      "videotoken": videoToken,
    };

    var url = baseUrl + "api/buddyup/startvirtualbuddyup";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    // print("done....${r.body}");
    return GeneralResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> endVirtualBuddyUp(
  token, {
  required String buddyUpId,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "virtualstatus": "COMPLETED",
      "buddyupid": buddyUpId,
    };

    var url = baseUrl + "api/buddyup/endvirtualbuddyup";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    return GeneralResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> startVirtualBooking(
  token, {
  required String videoToken,
  required String bookingId,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "virtualstatus": "STARTED",
      "bookingid": bookingId,
      "videotoken": videoToken,
    };

    var url = baseUrl + "api/booking/startvirtualbooking";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    // print("done....${r.body}");
    return GeneralResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> endVirtualBooking(
  token, {
  required String bookingId,
}) async {
  try {
    // print("postFeedback....");

    var map = {
      "virtualstatus": "COMPLETED",
      "bookingid": bookingId,
    };

    var url = baseUrl + "api/booking/endvirtualbooking";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    return GeneralResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return GeneralResponse(status: false);
  }
}
