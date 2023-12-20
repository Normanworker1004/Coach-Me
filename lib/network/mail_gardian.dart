import 'package:cme/model/find_user_by_phone_response.dart';
import 'package:cme/model/login_response.dart';
import 'package:cme/model/user_class.dart';
import 'package:cme/network/coach/request.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



Future<UserClass> sendMailGardian(
    {
      name: "Ayo Mi",
      guardianName: "Test Guardian",
      guardianPhone: "+2340056350378",
      guardianEmail: "guradtest@gmail.com",
      guardCountryId: "GB"
    }
    ) async {
  try {
    // print("creating...serb.");

    var map = {
      "name": name,
       "guardian_name": guardianName,
      "guardian_phone": guardianPhone,
      "guardian_email": guardianEmail,
    };

     print("creating...++++++.map ${map}");
    http.Response r =
        await http.post(
            Uri.parse("${baseUrl}api/auth/sendMailGardian"), body: map).catchError((e) {
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

