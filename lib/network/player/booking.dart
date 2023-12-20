import 'dart:convert';

import 'package:cme/model/create_booking_response.dart';
import 'package:cme/model/fetch_player_booking_resopnse.dart';
import 'package:cme/model/fetch_player_boot_camp_list.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

class CreateBookingClass {
  final bookingDates;
  final otherUsers;
  final coachId;
  final sessionMode;
  final price;
  final paymentCardId;
  final latOfBooking;
  final longOfBoking;
  final locationOfBooking;
  final paymentRefrence;

  CreateBookingClass(
      {required this.bookingDates,
      required this.otherUsers,
      required this.coachId,
      required this.sessionMode,
      required this.price,
      required this.paymentCardId,
      required this.latOfBooking,
      required this.longOfBoking,
      required this.locationOfBooking,
      required this.paymentRefrence});
}

Future<CreateBookingResponse> createBookingPlayer(
  token, {
  required CreateBookingClass b,
  isGiftCard: false,
}) async {
  try {
    // print(token);
    var map = {
      "bookingdates": b.bookingDates,
      "otheruser": b.otherUsers,
      "coach_id": "${b.coachId}",
      "nok": "",
      "nokRelationship": "",
      "nokPhone": "",
      "healthstatus": "",
      "sessionmode": "${b.sessionMode}",
      "price": "${b.price}",
      "paymentTitle": "Payment for Booking",
      "paymentType": "debit",
      "amount": "${b.price}",
      "paymentOption": isGiftCard ? "giftcard" : "creditcard",
      "paymentOptionID": "${b.paymentCardId}",
      "lon": "${b.longOfBoking}",
      "lat": "${b.latOfBooking}",
      "location": "${b.locationOfBooking}",
      "ref": "${b.paymentRefrence}",
    };

    print(map);
    var url = baseUrl + "api/booking/createbooking";
    http.Response r = await http
        .post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        // "Accept": "application/json",
      },
      body: map,
    )
        .catchError((e) {
      print("error....$e");
    });
    var v = CreateBookingResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    print(e);
    return CreateBookingResponse(
        status: false, message: "Error ocured creating bookking");
  }
}

Future<CreateBookingResponse> createBuddyUpBooking(token,
    {required CreateBookingClass b}) async {
  try {
    // print("approve");
    var map = {
      "bookingdates": b.bookingDates,
      "otheruser": b.otherUsers,
      "coach_id": "${b.coachId}",
      "nok": "",
      "nokRelationship": "",
      "nokPhone": "",
      "healthstatus": "",
      "sessionmode": "${b.sessionMode}",
      "price": "${b.price}",
      "paymentTitle": "Payment for Booking",
      "paymentType": "debit",
      "amount": "${b.price}",
      "paymentOption": "creditcard",
      "paymentOptionID": "${b.paymentCardId}",
      "lon": "${b.longOfBoking}",
      "lat": "${b.latOfBooking}",
      "location": "${b.locationOfBooking}",
      "ref": "${b.paymentRefrence}",
    };
    var url = baseUrl + "api/booking/createbooking";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    // print(r.body);
    var v = CreateBookingResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return CreateBookingResponse(status: false);
  }
}

Future<GeneralResponse2> updateBookingPlayer(
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
      "bookingid": jsonEncode(bookingid)
    };
    var url = baseUrl + "api/booking/updatebooking";
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

Future<FetchPlayerBookingResponse> fetchPlayerBooking(
  token,
) async {
  try {
    // print("approve");
    var url = baseUrl + "api/booking/player/fetchbooking";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
    );
     print(r.body); 
    var v = FetchPlayerBookingResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return FetchPlayerBookingResponse(status: false, message: "Error occured");
  }
}

Future<FetchPlayerBootCampListResponse> fetchPlayerBootCampList(token) async {
  try {
    // print("approve");
    var url = baseUrl + "api/bootcamp/fetchplayerbootcamp";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
    );
    var v = FetchPlayerBootCampListResponse.fromJson(jsonDecode(r.body));

    return v;
  } catch (e) {
    return FetchPlayerBootCampListResponse(
        status: false, message: "Error occured");
  }
}
