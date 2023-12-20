import 'dart:convert';

import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<GeneralResponse2> sendGiftCard(token,
    {required phone,
      required price,
      required paymentCardId,
      required paymentRefrence}) async {
  try {
    // print(token);
    var map = {
      "amount": "$price",
      "phone": "$phone",
      "reason": "Enjoy the gift card",
      "ref": "$paymentRefrence",
      "paymentTitle": "Payment for Gift card to $phone",
      "paymentType": "debit",
      "paymentOption": "creditcard",
      "paymentOptionID": "$paymentCardId",
    };

    print(map);
    var url = baseUrl + "api/general/addgiftcard";
    // print(url);
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
        // "Accept": "application/json",
      },
      body: map,
    );
    print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body));
    // print(v.status);
    return v;
  } catch (e) {
    // print(e);
    return GeneralResponse2(
        status: false, message: "Error ocured creating bookking");
  }
}


Future<bool> canSendGiftCardToUser(token,
    {required phone }) async {
  try {
    // print(token);
    var map = {
       "phone": "$phone",
    };

    print(map);
    var url = baseUrl + "api/general/canSendGiftCardToUser";
    // print(url);
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
       },
      body: map,
    );
    print(r.body);
    var v = GeneralResponse2.fromJson(jsonDecode(r.body.toString()));
     print(v.status);
    return v.status ?? false;
  } catch (e) {
    print(e);
    return false;
  }
}
