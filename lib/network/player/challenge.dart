import 'dart:convert';

import 'package:cme/model/create_buddy_up_response.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

class CreateChallengeBookingClass {
  final bookingDates;
  final bookingtime;
  final startTime;
  final sessionMode;
  final latOfBooking;
  final longOfBoking;
  final locationOfBooking;
  final player2Id;
  final tryOut;
  final gamePlay;
  final sport;

  CreateChallengeBookingClass({
    required this.bookingDates,
    required this.bookingtime,
    required this.startTime,
    required this.sessionMode,
    required this.latOfBooking,
    required this.longOfBoking,
    required this.locationOfBooking,
    required this.player2Id,
    required this.tryOut,
    required this.sport,
    required this.gamePlay,
  });
}

Future<GeneralResponse> updateChallengeBookingDetails(token, bookingid,
    {required CreateChallengeBookingClass b}) async {
  try {
    // print("$token");
    var map = {
      "bookingid": "$bookingid",
      "bookingDates": "${b.bookingDates}",
      "bookingtime": "${b.bookingtime}",
      "start_time": "${b.startTime}",
      "end_time": "${b.startTime}",
      "lon": "${b.longOfBoking}",
      "lat": "${b.latOfBooking}",
      "location": "${b.locationOfBooking}",
      "sessionmode": "${b.sessionMode}",
      "tryout": "${b.tryOut}",
      "gameplay": "${b.gamePlay}",
    };

    // print("process....2");
    var url = baseUrl + "api/challenge/updatechallengedates";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );

    // print("process....3");
    print(r.body);
    var v = GeneralResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print("errore.....$e");
    return GeneralResponse(status: false, message: "Error creating booking");
  }
}

Future<CreateBuddyBookingResponse> createChallengeBooking(token,
    {required CreateChallengeBookingClass b}) async {
  try {
    // print("$token");
    var map = {
      "bookingDates": "${b.bookingDates}",
      "bookingtime": "${b.bookingtime}",
      "start_time": "${b.startTime}",
      "end_time": "${b.startTime}",
      "player2_id": "${b.player2Id}",
      "lon": "${b.longOfBoking}",
      "lat": "${b.latOfBooking}",
      "location": "${b.locationOfBooking}",
      "sessionmode": "${b.sessionMode}",
      "tryout": "${b.tryOut}",
      "gameplay": "${b.gamePlay}",
      "sport": "${b.sport}",
    };

    // print("process....2");
    var url = baseUrl + "api/challenge/createchallenge";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );

    // print("process....3");
    // print(r.body);
    var v = CreateBuddyBookingResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print("errore.....$e");
    return CreateBuddyBookingResponse(
        status: false, message: "Error creating booking");
  }
}

Future<GeneralResponse> updateChallengeBooking(
  token, {
  required String nok,
  required String nokRelationship,
  required String nokPhone,
  required healthstatus,
  required bookingid,
}) async {
  try {
    var map = {
      "nok": "$nok",
      "nokRelationship": "$nokRelationship",
      "nokPhone": "$nokPhone",
      "healthstatus": jsonEncode(healthstatus),
      "challengeid": "$bookingid"
    };
    var url = baseUrl + "api/challenge/updatechallenge";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    // print(r.body);
    var v = GeneralResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse(status: false);
  }
}

Future<FetchChallengeBookingResponse> fetchPlayerChallengeBooking(token) async {
  try {
    // print("$token");

    var url = baseUrl + "api/challenge/playerfetchchallenge";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
    );
    // print(r.body);
    var v = FetchChallengeBookingResponse.fromJson(jsonDecode(r.body));
    // print("lenght.....${v.details.length}");
    return v;
  } catch (e) {
    print(e);
    return FetchChallengeBookingResponse(status: false);
  }
}

Future<GeneralResponse> approveChallengeBooking(
  token, {
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {"challengeid": "$bookingid"};
    var url = baseUrl + "api/challenge/approvechallenge";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    // print(r.body);
    var v = GeneralResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> deleteChallengeBooking(
  token, {
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {"bookid": "$bookingid"};
    var url = baseUrl + "api/challenge/deletechallenge";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    // print(r.body);
    var v = GeneralResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse> declineChallengeBooking(
  token, {
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {"challengeid": "$bookingid"};
    var url = baseUrl + "api/challenge/declinechallenge";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    // print(r.body);
    var v = GeneralResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse(status: false);
  }
}

Future<GeneralResponse2> uploadChallengeScores(
  token, {
  required player1,
  required player2,
  required score1,
  required score2,
  required win,
  required loose,
  required challengeId,
}) async {
  try {
    // print("approve");
    var map = {
      "player1": "$player1",
      "player2": "$player2",
      "score1": "$score1",
      "score2": "$score2",
      "win": "$win",
      "loose": "$loose",
      "challenge_id": "$challengeId",
    };
    var url = baseUrl + "api/challenge/createscore";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    // print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse2(status: false);
  }
}

Future<GeneralResponse2> updateBlockChallengeFrom(
  token, {
  required List<int>? blocList,
}) async {
  try {
    // print("approve");
    var map = {
      "level": jsonEncode(blocList),
    };
    var url = baseUrl + "api/general/level_blocker";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse2(status: false);
  }
}



