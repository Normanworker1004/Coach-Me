import 'package:cme/model/find_user_by_phone_response.dart';
import 'package:cme/model/login_response.dart';
import 'package:cme/model/user_class.dart';
import 'package:cme/network/coach/request.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<FindUserByPhoneResponse> findUserByPhone({phoneNo}) async {
  print("Log in....");
  try {
    var url = baseUrl + "api/general/findphone";
    http.Response res = await http.post(
      Uri.parse(url),
      body: <String, String?>{
        "phone": phoneNo,
      },
    );
    print("login....${res.body}");
    var r = FindUserByPhoneResponse.fromJson(jsonDecode(res.body));

    return r;
  } catch (e) {
    print("Error occured....$e");
    return FindUserByPhoneResponse(
        status: false, message: "Error occured...Try Again");
  }
}

Future<FindUserByPhoneResponse> resetPassword({
  required newPassWord,
  required userId,
}) async {
  print("new passwrod....$newPassWord");
  try {
    var url = baseUrl + "api/general/updatepassword";
    http.Response res = await http.post(
      Uri.parse(url),
      body: <String, String>{
        "password": "$newPassWord",
        "userid": "$userId",
      },
    );
    print("login....${res.body}");
    var r = FindUserByPhoneResponse.fromJson(jsonDecode(res.body));

    return r;
  } catch (e) {
    print("Error occured....$e");
    return FindUserByPhoneResponse(
        status: false, message: "Error occured...Try Again");
  }
}

Future<LogInResponse> loginUser({username, password}) async {
  print("Log in....${baseUrl}api/auth/signin");
  try {
    http.Response res = await http.post(
      Uri.parse("${baseUrl}api/auth/signin"),
      body: <String, String?>{
        "username": username,
        "password": password,
      },
    );
    print("login1....${res.body}");
    LogInResponse logInresponse;
    try {
      var r = LogInResponse.fromJson(jsonDecode(res.body));
      logInresponse = r;
    } catch (e) {
      logInresponse = LogInResponse(reason: res.body);
    }
    return logInresponse;
  } catch (e) {
    print("Error occured....$e");
    return LogInResponse(reason: "Error occured...Try Again");
  }
}

Future verifyEmail({required email, required phone}) async {
  try {
     print("verify...${jsonEncode(<String, String>{"email": email,"phone": phone,})}");
    var url = baseUrl + "api/auth/verifyemailandphone";
    http.Response r = await http
        .post(
      Uri.parse(url),
      body: <String, String>{
        "email": email,
        "phone": phone,
      },
    )
        .catchError((e) {
      print("111111Error occured....can't verify..$e");
    });

    print("resp........$r");
    print("${r.body}");
    return jsonDecode(r.body)["message"];
  } catch (e) {
    print("Error ..$e");
    return "Error occured...can't verify number";
  }
}

Future<UserClass> createAccount(
    {name: "Ayo Mi",
    email: "demo01342@gmail.comp",
    password: "123456",
    ageGroup: "18+",
    countryId: "GB",
    dob: " 27-12-1990",
    phone: "+442234503677",
    guardianName: "Test Guardian",
    guardianDob: "27-12-1990",
    guardianPhone: "+2340056350378",
    guardianEmail: "guradtest@gmail.com",
    guardCountryId: " GB",
    referedBy: " deubd",
    gender: "male",
    subscriptionId: "2",
    markerting: " Whatsapp",
    type: "player",
    lon: "2.0",
    lat: "4.895",
    List<String> sports: const [],
    List<int?> experienceLevel: const []}) async {
  try {
    // print("creating...serb.");
    var mp = {"sport": sports, "level": experienceLevel};

    var map = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "sport": jsonEncode(mp),
      "age_group": ageGroup,
      "country_id": countryId,
      "dob": dob,
       "guardian_name": guardianName,
      "guardian_dob": guardianDob,
      "guardian_phone": guardianPhone,
      "guardian_email": guardianEmail,
      "guard_country_id": guardianDob,
      "refered_by": referedBy,
      "gender": gender,
      "subscription_id": subscriptionId,
      "markerting": markerting,
      // // "usertype"
      "type": type,
      "lon": "$lon",
      "lat": "$lat",
    };

     print("creating...++++++.map ${map}");
    http.Response r =
        await http.post(
            Uri.parse("${baseUrl}api/auth/signup"), body: map).catchError((e) {
        print("error in regustration.....$e");
    });
      print("token: ${r.body}");
    UserClass u = UserClass.fromJson(jsonDecode(r.body));
      print("cmplrte...api side....");
    return u;
  } catch (e) {
    // print("Erorororo...$e");
    return UserClass(status: false); //"Unable to create account $e";
  }
}

Future getAllSports() async {
  var url = baseUrl + "api/auth/allsport";
  // print(url);
  Response res = await Dio().get(url);
  // print(res.data);
}
