import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> launchMap(
    {@required String? lat = "47.6", @required String? long = "-122.3"}) async {
  // var mapSchema = 'geo:$lat,$long';
  // print(mapSchema);
  var url = 'https://www.google.com/maps/dir/?api=1'
      '&destination=$lat,$long'
      '&travelmode=driving&dir_action=navigate';
  if (await canLaunch(url)) {
    await launch(url);
    return "Opening Map";
  } else {
    return 'Could not launch Map';
  }
}
