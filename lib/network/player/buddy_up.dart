import 'dart:convert';

import 'package:cme/model/create_buddy_up_response.dart';
import 'package:cme/model/fetch_buddy_up_resopnse.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

class CreateBuddyBookingClass {
  final bookingDates;
  final bookingtime;
  final int startTime;
  final sessionMode;
  final latOfBooking;
  final longOfBoking;
  final locationOfBooking;
  final player2Id;
  final sport;

  CreateBuddyBookingClass(
      {required this.bookingDates,
      required this.bookingtime,
      required this.startTime,
      required this.sessionMode,
      required this.latOfBooking,
      required this.longOfBoking,
      required this.locationOfBooking,
      required this.sport,
      required this.player2Id});
}

Future<GeneralResponse> updateBuddyUpBookingDetails(token, id,
    {required CreateBuddyBookingClass b}) async {
  try {
    // print("process....1");
    var map = {
      "bookingDates": "${b.bookingDates}",
      "bookingid": "$id",
      "bookingtime": b.bookingtime, // "${b.bookingtime}",
      "start_time": "${b.startTime}",
      "end_time": "${b.startTime + 1}",
      "lon": "${b.longOfBoking}",
      "lat": "${b.latOfBooking}",
      "location": "${b.locationOfBooking}",
      "sessionmode": "${b.sessionMode}",
    };

    // print("process....2");
    var url = baseUrl + "api/buddyup/updatebuddydates";
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
    print(e);
    return GeneralResponse(status: false, message: "Error cretaing bo0kinmg");
  }
}

Future<CreateBuddyBookingResponse> createBuddyUpBooking(token,
    {required CreateBuddyBookingClass b}) async {
  try {
    // print("process....1");
    var map = {
      "bookingDates": "${b.bookingDates}",
      "bookingtime": b.bookingtime, // "${b.bookingtime}",
      "start_time": "${b.startTime}",
      "end_time": "${b.startTime + 1}",
      "player2_id": "${b.player2Id}",
      "lon": "${b.longOfBoking}",
      "lat": "${b.latOfBooking}",
      "location": "${b.locationOfBooking}",
      "sessionmode": "${b.sessionMode}",
      "sport": "${b.sport}",
    };

    // print("process....2");
    var url = baseUrl + "api/buddyup/createbuddyup";
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
    // print(e);
    return CreateBuddyBookingResponse(
        status: false, message: "Error cretaing bo0kinmg");
  }
}

Future<GeneralResponse> updateBuddyUpBooking(
  token, {
  required String nok,
  required String nokRelationship,
  required String nokPhone,
  required healthstatus,
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {
      "nok": "$nok",
      "nokRelationship": "$nokRelationship",
      "nokPhone": "$nokPhone",
      "healthstatus": jsonEncode(healthstatus),
      "bookingid": "$bookingid"
    };
    var url = baseUrl + "api/buddyup/updatebuddyup";
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

Future<FetchPlayerBuddyUpResponse> fetchPlayerBuddyUpBooking(token) async {
  try {
    // print("approve");

    var url = baseUrl + "api/buddyup/playerfetchbuddyup";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
    );
    // print(r.body);
    var v = FetchPlayerBuddyUpResponse.fromJson(jsonDecode(r.body));
    // print("lenght.....${v.details.length}");
    return v;
  } catch (e) {
    // print(e);
    return FetchPlayerBuddyUpResponse(status: false);
  }
}

Future<GeneralResponse> approveBuddyUpBooking(
  token, {
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {"buddyupid": "$bookingid"};
    var url = baseUrl + "api/buddyup/approvebuddyup";
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

Future<GeneralResponse> declineBuddyUpBooking(
  token, {
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {"buddyid": "$bookingid"};
    var url = baseUrl + "api/buddyup/declinebuddyup";
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

Future<GeneralResponse> deleteSentBuddyUpBooking(
  token, {
  required bookingid,
}) async {
  try {
    // print("approve");
    var map = {"bookid": "$bookingid"};
    var url = baseUrl + "api/buddyup/deletebuddyup";
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
