import 'package:cme/model/boot_camp_join_response.dart';
import 'dart:convert';

import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<BootCampJoinResponse> joinBootCamp(
  token, {
  required bootCampId,
  required coachName,
  required amount,
  required cardId,
  required paymentRef,
}) async {
  try {
    // print("approve");
    var map = {
      "bootcampid": bootCampId,
      "paymentTitle": "Payment for Joining Bootcamp by $coachName",
      "paymentType": "debit",
      "amount": "$amount",
      "paymentOption": "creditcard",
      "paymentOptionID": "$cardId",
      "ref": "$paymentRef",
    };
    var url = baseUrl + "api/general/joinSinglebBootcamp";
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        "Accept": "application/json",
      },
      body: map,
    );
    print(r.body);
    var v = BootCampJoinResponse.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return BootCampJoinResponse(status: false, message: "$e");
  }
}
