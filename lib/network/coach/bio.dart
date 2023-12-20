import 'dart:convert';

import 'package:cme/model/bio_response.dart';
import 'package:cme/model/bootcamp_class.dart';
import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/fetch_certificate_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<BootCampClass> saveBio({
  required token,
  sport: "Football",
  price: "20",
  description: "Lorem Ipsum Lorem Ipsum Lorem Ipsum",
  location: "Lagos",
  lon: "2.0",
  lat: "2.80",
  capacity: "10",
  bootcamptime:
      "[{\"time\":\"7:80\"},{\"time\":\"7:80\"},{\"time\":\"7:80\"},{\"time\":\"7:80\"},{\"time\":\"7:80\"}]",
}) async {
  // print("token: $token");
  try {
    var map = {
      "sport": sport,
      "price": price,
      "description": description,
      "location": location,
      "lon": lon,
      "lat": lat,
      "capacity": capacity,
      "bootcamptime": bootcamptime,
    };

    http.Response r = await http.post(Uri.parse("${baseUrl}api/bootcamp/createbootcamp"),
        headers: {
          "x-access-token": token,
          "Accept": "application/json",
        },
        body: map);
    var u = BootCampClass.fromJson(jsonDecode(r.body));

    return u;
  } catch (e) {
    return BootCampClass(message: "Error occured");
  }
}

Future<BioResponse> fetchBio(token) async {
  try {
    // print("fetch bio");
    var url = baseUrl + "api/bio/fetchbio";
    // print(url);

    // print(token);

    http.Response r = await http.get(
        Uri.parse(url),
      headers: {"x-access-token": token, "Accept": "application/json"},
    );

    // print(jsonDecode(r.body)['Profile']);
    return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return BioResponse(status: false);
  }
}

Future<CoachBioFullInfoResponse> fetchCompleteBio(token) async {
  try {
    var url = baseUrl + "api/bioinfo/fetchbio";

    http.Response r = await http.get(
        Uri.parse(url),
      headers: {"x-access-token": token, "Accept": "application/json"},
    );

    // print(jsonDecode(r.body));
    return CoachBioFullInfoResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return CoachBioFullInfoResponse(
      bioSubDetaiList: [],
      status: false,
      description: "Error occured",
    );
  }
}

Future updatePhoneVerification(token) async {
  try {
    // print("fetch bio");
    var url = baseUrl + "api/auth/updatephone";

    // print(token);
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    // print(r.body);
    // return BioResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // return BioResponse(status: false);
  }
}

Future<GeneralResponse2> saveCoachBioDetail(
  token, {
  required bioid,
  required sport,
  required level,
  required lat,
  required lon,
  required location,
  required radius,
  required sessionPrice,
  required ageGroup,
  required expertise,
  required gamePlay,
  required aboutme,
}) async {
  try {
    print("new fullname: ....");
    var map = {
      "bioid": "$bioid",
      "sport": "$sport",
      "level": "$level",
      "location": "$location",
      "lat": "$lat",
      "lon": "$lon",
      "radius": "$radius",
      "price": "$sessionPrice",
      "age_group": "$ageGroup",
      "expertise": "$expertise",
      "gameplay": "$gamePlay",
      "about": "$aboutme",
    };

    print("Saving........$map");
    http.Response r = await http
        .post(Uri.parse("${baseUrl}api/bio/updatebio"),
            headers: {
              "x-access-token": token,
            },
            body: map)
        .catchError((e) {
      // print("Error:  $e");
    });

    var u = GeneralResponse2.fromJson(jsonDecode(r.body));
    print(r.body);
    print("udate done......");
    return u;
  } catch (e) {
    return GeneralResponse2(status: false, message: "Error occured");
  }
}

Future<StreamedResponse?> uploadCoachCertificates(
  token, {
  required String filePath,
}) async {
  try {
    print("file path...$filePath");
    var url = baseUrl + "api/general/uploadcert";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.headers['x-access-token'] = token;

    request.files.add(await http.MultipartFile.fromPath('certificate', filePath));
    return await request.send();
  } catch (e) {
    print("error uploading....$e");
    return null;
  }
}

Future<FetchCertificateResponse> fetchCoachCertificates(token) async {
  try {
    var url = baseUrl + "api/general/findcertificate";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    print(r.body);
    var v = FetchCertificateResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return FetchCertificateResponse(status: false, message: "Error occured.");
  }
}

Future<GeneralResponse2> deleteCoachCertificate(
  token, {
  required certificateid,
}) async {
  try {
    // print("approve");
    var map = {"certificateid": "$certificateid"};
    var url = baseUrl + "api/general/deletecertificate";
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
