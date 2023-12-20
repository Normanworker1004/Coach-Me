import 'dart:convert';

import 'package:cme/model/contact_filter_response.dart';
import 'package:cme/network/coach/request.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:http/http.dart' as http;

Future<FilterContactResponse> filterUserContact({
  required String token,
  required String? countryCode,
}) async {
  try {
    var l = await filterContacts();
    var map = {
      "userlist": jsonEncode(l),
      "country": "$countryCode",
    };

    var url = baseUrl + "api/general/processphone";
    http.Response r = await http.post(Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
        body: map);
    return FilterContactResponse.fromJson(jsonDecode(r.body));
  } catch (e) {
    return FilterContactResponse(status: false);
  }
}

Future<List<String>> filterContacts() async {
  Iterable<Contact> test =
      await ContactsService.getContacts(withThumbnails: false);
  var contactPhone = test.map((e) {
    var r = e.phones!.toList();
    String phone = "";
    for (var i = 0; i < r.length; i++) {
      var item = r[i].value!.replaceAll("-", "").replaceAll(" ", "");

      phone += i + 1 < r.length ? "$item," : "$item";
    }
    return phone;
  }).toList();

  // print("total:$contactPhone");
  return contactPhone;
}
