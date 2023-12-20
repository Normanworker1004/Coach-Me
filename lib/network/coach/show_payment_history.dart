import 'dart:convert';

import 'package:cme/model/fetch_paymnet_history_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<FetchPaymentHistoryResponse> fetchPaymentHistory(String token) async {
  try {
    // print("done....");
    var url = baseUrl + "api/general/viewpaymenthistory";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    // print("done....${r.body}");
    var pH = FetchPaymentHistoryResponse.fromJson(jsonDecode(r.body));

    // print("done");
    // print(bootCamp.details.length);
    return pH;
  } catch (e) {
    // print(e);
    return FetchPaymentHistoryResponse(status: false, message: "Error");
  }
}
