import 'dart:convert';
import 'package:cme/model/bootcamp_class.dart';
import 'package:cme/model/coach_session_response.dart';
import 'package:cme/model/fetch_coach_bootcamp_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/model/user_profile_class.dart';
import 'package:http/http.dart' as http;

String baseUrl =

//    "http://178.248.109.145:3000/"; //tayo's office
  "https://coach-and-me-284109.ew.r.appspot.com/";
//  "http://192.168.1.14:3000/";
 // "http://192.168.0.17:3000/";

Future<UserProfile?> saveAccountInfo(
  token, {
  required fullname,
  required alias,
  required dob,
  // @required password,
  required accountname,
  required bankname,
  required accountnumber,
  required sortcode,
}) async {
  try {
    // print("new fullname: $fullname");
    var map = {
      "fullname": fullname,
      "alias": alias,
      "dob": dob,
      // "password": password,
      "accountname": accountname,
      "bankname": bankname,
      "accountnumber": accountnumber,
      "sortcode": sortcode,
    };

    // print("Saving........");
    http.Response r = await http.post(
        Uri.parse("${baseUrl}api/coach/saveaccountinfo"),
        headers: {
          "x-access-token": token,
          "Accept": "application/json",
        },
        body: map);

    var u = UserProfile.fromJson(jsonDecode(r.body));
    // print(u.status);
    // print("udate done......");
    return u;
  } catch (e) {
    return null;
  }
}

Future<UserProfile> showProfile(String localToken) async {
  try {
    var url = baseUrl + "api/coach/showprofile";
    // print(url);

    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": localToken,
      },
    ).catchError((e) {
      // print("Errorrrr....$e");
    });
    // print(r.body);
    var u = UserProfile.fromJson(jsonDecode(r.body));

    // print(u.message.userdetails.toJson());
    return u;
  } catch (e) {
    print("error...$e");
    return UserProfile(status: false);
  }
}

Future<FetchCoachBootCampResponse> fetchBootCamp(String token) async {
  try {
    // print("done....");
    var url = baseUrl + "api/bootcamp/fetchbootcamp";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    // print("done....");
    var bootCamp = FetchCoachBootCampResponse.fromJson(jsonDecode(r.body));

    // print("done");
    // print(bootCamp.details.length);
    return bootCamp;
  } catch (e) {
    print(e);
    return FetchCoachBootCampResponse(status: false, message: "Error");
  }
}

Future<GeneralResponse2> createBootCamp(
    {required token,
    required bootCampDate,
    required price,
    required description,
    required location,
    required lon,
    required lat,
    required capacity,
    required name,
    required bootcamptime}) async {
  print("token: $bootcamptime");
  try {
    var map = {
      "name": "$name",
      "bootCampDate": bootCampDate,
      "price": "$price",
      "description": "$description",
      "location": "$location",
      "lon": "$lon",
      "lat": "$lat",
      "capacity": "$capacity",
      "bootcamptime": "$bootcamptime",
    };
    

    print(map);
    var url = baseUrl + "api/bootcamp/createbootcamp";
    http.Response r = await http
        .post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    )
        .catchError((e) {
      print("Eror....$e");
    });
    print(r.body);
    GeneralResponse2 u = GeneralResponse2.fromJson(jsonDecode(r.body));

    // print("boot camp....${u.message}");
    return u;
  } catch (e) {
    print("error........$e");
    return GeneralResponse2(status: false, message: "Error occured");
  }
}

Future<GeneralResponse> updateBootCamp(
    {required token,
    required bookingId,
    required bootCampDate,
    required price,
    required description,
    required location,
    required lon,
    required lat,
    required capacity,
    required name,
    required bootcamptime}) async {
  print("token: $bootcamptime");
  try {
    var map = {
      "bookingid": "$bookingId",
      "name": "$name",
      "dates": "$bootCampDate",
      "price": "$price",
      "description": "$description",
      "location": "$location",
      "lon": "$lon",
      "lat": "$lat",
      "capacity": "$capacity",
      "bootcamptime": "$bootcamptime",
    };

    print(map);
    var url = baseUrl + "api/booking/updatebootcampinfo";
    http.Response r = await http
        .post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    )
        .catchError((e) {
      print("Eror....$e");
    });
    print(r.body);
    GeneralResponse u = GeneralResponse.fromJson(jsonDecode(r.body));

    return u;
  } catch (e) {
    print("error........$e");
    return GeneralResponse(status: false, message: "Error occured");
  }
}

Future<BootCampClass> createBooking({
  required token,
  bookingdates:
      " [{\"dates\":\"27-09-2020\",\"time\":[\"07:30\",\"07:30\",\"07:30\"]},{\"dates\":\"27-09-2020\",\"time\":[\"7:30\"]}]",
  otheruser:
      " [{\"phone\":\"+2347030506474\"},{\"phone\":\"+2347030506474\"},{\"phone\":\"+2347030506474\"},{\"phone\":\"+2347030506474\"},{\"phone\":\"+2347030506474\"}]",
  coachId: "12",
  nok: "Gbogboade Ayomide",
  nokRelationship: "brother",
  nokPhone: "+2348136460010",
  healthstatus: "goof",
  sessionmode: "physical",
}) async {
  try {
    var map = {
      "bookingdates": bookingdates,
      "otheruser": otheruser,
      "coach_id": coachId,
      "nok": nok,
      "nokRelationship": nokRelationship,
      "nokPhone": nokPhone,
      "healthstatus": healthstatus,
      "sessionmode": sessionmode,
    };

    await http.post(
        Uri.parse("${baseUrl}api/booking/createbooking"),
        headers: {
          "x-access-token": token,
        },
        body: map);
    return BootCampClass(message: "Done"); //TODO FIX CREATE BOOKING
  } catch (e) {
    return BootCampClass(message: "Error occured");
  }
}

Future<CoachSessionResponse> fetchSessions(String token) async {
  try {
    http.Response r = await http.get(
      Uri.parse("${baseUrl}api/session/fetchtodaysession/coach"),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
    );
    // print(r.body);
    var c = CoachSessionResponse.fromJson(jsonDecode(r.body));
    // print(c.status);
    return c;
  } catch (e) {
    // print("Error occured");
    return CoachSessionResponse();
  }
}
