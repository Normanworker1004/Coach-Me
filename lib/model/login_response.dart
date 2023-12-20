// class LogInResponse {
//   bool auth;
//   String accessToken;
//   String reason;

//   LogInResponse({this.auth, this.accessToken, this.reason});

//   LogInResponse.fromJson(Map<String, dynamic> json) {
//     auth = json['auth'];
//     accessToken = json['accessToken'];
//     reason = json['reason'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['auth'] = this.auth;
//     data['accessToken'] = this.accessToken;
//     data['reason'] = this.reason;
//     return data;
//   }
// }

import 'package:cme/model/user_class/user_details.dart';

class LogInResponse {
  bool? auth;
  String? accessToken;
  Userdetails? userDetails;
  String? reason;

  LogInResponse({
    this.auth,
    this.accessToken,
    this.userDetails,
    this.reason,
  });

  LogInResponse.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    accessToken = json['accessToken'];
    userDetails = json['details'] != null
        ? new Userdetails.fromJson(json['details'])
        : null;
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth;
    data['accessToken'] = this.accessToken;
    if (this.userDetails != null) {
      data['details'] = this.userDetails!.toJson();
    }
    data['reason'] = this.reason;
    return data;
  }
}
