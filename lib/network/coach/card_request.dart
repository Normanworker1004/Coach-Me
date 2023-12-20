import 'dart:convert';

import 'package:cme/model/add_card_response.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/model/payment_card_update.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<FetchCardsResponse> fetchCards(token) async {
  try {
    var url = baseUrl + "api/general/showcards";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );

    return FetchCardsResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchCardsResponse();
  }
}

Future<AddCardResponse> addCard(
  token, {
  nameOnCard: "Ola 2",
  expiryDate: "01/22",
  cardType: "Verve",
  cardkey: "0000000000",
  ccv: "730",
}) async {
  try {
    var map = {
      "nameOnCard": nameOnCard,
      "expiryDate": expiryDate,
      "cardType": cardType,
      "ccv": ccv,
      "cardkey": cardkey,
    };

    // print("Saving........");
    http.Response r = await http.post(
        Uri.parse("${baseUrl}api/general/addcard"),
        headers: {
          "x-access-token": token,
        },
        body: map);

    return AddCardResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print("error occured: $e");
    return AddCardResponse(status: false, message: "Error Occured");
  }
}

Future addGiftCard(
  token, {
  amount: "1000",
  phone: "+2348136460030",
}) async {
  try {
    var map = {
      "amount": amount,
      "phone": phone,
    };

    // print("Saving........");
    http.Response r = await http.post(
        Uri.parse("${baseUrl}api/general/addgiftcard"),
        headers: {
          "x-access-token": token,
        },
        body: map);

    // var u = AddCardResponse.fromJson(jsonDecode(r.body));
    // print(u.status);
    // print(" done...... ${r.body}");
  } catch (e) {
    // print("error occured: $e");
  }
}

Future<PaymentCardUpdateResponse> updatePaymentCard(
  token, {
  nameOnCard: "Ola 2",
  expiryDate: "01/22",
  cardType: "Verve",
  cardkey: "0000000000",
  ccv: "730",
  id: "730",
}) async {
  try {
    var map = {
      "nameOnCard": nameOnCard,
      "expiryDate": expiryDate,
      "cardType": cardType,
      "ccv": ccv,
      "cardkey": cardkey,
      "cardid": id,
    };

    // print("updating........");
    http.Response r = await http.post(
        Uri.parse("${baseUrl}api/general/updatepaymentcard"),
        headers: {
          "x-access-token": token,
        },
        body: map);
    // print("${r.body}");
    return PaymentCardUpdateResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print("error occured: $e");
    return PaymentCardUpdateResponse(status: false, message: "Error Occurred");
  }
}

Future<PaymentCardUpdateResponse> deletePaymentCard(
  token, {
  id: "730",
}) async {
  try {
    var map = {
      "cardid": id,
    };

    // print("updating........");
    http.Response r = await http.post(
        Uri.parse("${baseUrl}api/general/deletepaymentcard"),
        headers: {
          "x-access-token": token,
        },
        body: map);
    // print("${r.body}");
    return PaymentCardUpdateResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    // print("error occured: $e");
    return PaymentCardUpdateResponse(status: false, message: "Error Occured");
  }
}
