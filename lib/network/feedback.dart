import 'dart:convert';

import 'package:cme/model/feedback_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:http/http.dart' as http;

Future<FeedbackResponse> addFeedBack(
    {required String token,
    required String? name,
    required String message}) async {
  try {
    // print("postFeedback....");

    var map = {
      "name": name,
      "message": message,
    };

    var url = baseUrl + "api/general/createfeedback";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    // print("done....${r.body}");
    return FeedbackResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FeedbackResponse(status: false);
  }
}
