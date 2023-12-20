import 'dart:convert';

import 'package:cme/model/coach_booking_deleted_response.dart';
import 'package:cme/model/coach_booking_note_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<CoachBookingResponse> findUser(
  token, {
  required String bookid,
}) async {
  try {
    // print("reject");
    var map = {"bookid": bookid};
    var url = baseUrl + "api/booking/declinebooking";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );
    // print(r.body);
    var v = CoachBookingResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return CoachBookingResponse(status: false);
  }
}

Future<CoachBookingResponse> fetchBoking(token,
    {status //: "accepted" //"pending",
    }) async {
  try {
    var map = {"status": status};
    var url = baseUrl + "api/booking/coach/fetchbooking";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );
    print(r.body);
    var v = CoachBookingResponse.fromJson(jsonDecode(r.body));
    print("status:  ........${v.status}");
    return v;
  } catch (e) {
    print("errorr....$e");
    return CoachBookingResponse(status: false);
  }
}

Future<GeneralResponse2> approveBooking(
  token, {
  required String bookid,
  required String? location,
  required String lon,
  required String lat,
}) async {
  try {
    print("approve");
    var map = {
      "bookid": "$bookid",
      "location": "$location",
      "lon": "$lon",
      "lat": "$lat",
    };
    var url = baseUrl + "api/booking/approvebooking";
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
    print("error....$e");
    return GeneralResponse2(status: false, message: "Error Occured");
  }
}

Future<GeneralResponse2> rejectBooking(
  token, {
  required String bookid,
}) async {
  try {
    print("reject");
    var map = {"bookid": bookid};
    var url = baseUrl + "api/booking/declinebooking";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );
    print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse2(status: false, message: "Error occured.");
  }
}

Future<CoachBookingDeletedResponse> deleteBooking(
  token, {
  required String bookid,
}) async {
  try {
    // print("reject");
    var map = {"bookid": bookid};
    var url = baseUrl + "api/booking/cancelbooking";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );
    print(r.body);
    var v = CoachBookingDeletedResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return CoachBookingDeletedResponse(message: "Error occured");
  }
}

Future<CoachBookingDeletedResponse> deleteBookingPlayer(
  token, {
  required String bookid,
}) async {
  try {
    // print("reject");
    var map = {"bookid": bookid};
    var url = baseUrl + "api/player/deletebooking";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );
    print(r.body);
    var v = CoachBookingDeletedResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return CoachBookingDeletedResponse(message: "Error occured");
  }
}

Future<CoachBookingNoteResponse> addBookingNote(
  token, {
  required String bookid,
  required String date,
  required String note,
}) async {
  try {
    var m = {
      "date": date,
      "note": note,
    };

    var j = jsonEncode(m);

    // print("note to json:$j");

    var map = {
      "bookid": bookid,
      "note": j,
    };
    var url = baseUrl + "api/booking/leavenote";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
      body: map,
    );
    // print(r.body);
    var v = CoachBookingNoteResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    print(e);
    return CoachBookingNoteResponse(message: "Error occured");
  }
}
