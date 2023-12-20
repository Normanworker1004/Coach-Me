import 'dart:convert';

import 'package:cme/model/fetch_notification_count_response.dart';
import 'package:cme/model/fetch_notification_response.dart';
import 'package:cme/network/coach/request.dart';

import 'package:http/http.dart' as http;

Future<FetchNotificationResponse> fetchNotificationsData({
  required String token,
}) async {
  try {
    var url = baseUrl + "api/general/fetchnotification";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    print(r.body);
    return FetchNotificationResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchNotificationResponse(status: false);
  }
}

Future<FetchNotificationsCountResponse> fetchCountNotifications( {
  required String token,
}) async {
  try {
    var url = baseUrl + "api/general/countunreadnotification";
    http.Response r = await http.get(
      Uri.parse(url),
      headers: {
        "x-access-token": token,
      },
    );
    print(r.body);
    return FetchNotificationsCountResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchNotificationsCountResponse(status: false, count: 0);
  }
}

Future<FetchNotificationResponse> clearNotifications(
    {required String token, List<int?>? idList}) async {
  try {
    var url = baseUrl + "api/general/clearnotification";
    var map = {"notificationid": jsonEncode(idList)};
    http.Response r = await http.post(
      Uri.parse(url),
      body: map,
      headers: {
        "x-access-token": token,
      },
    );
    print(r.body);
    return FetchNotificationResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FetchNotificationResponse(status: false);
  }
}
