import 'package:cme/model/user_class/user_details.dart';

class FindUserByPhoneResponse {
  bool? status;
  String? message;
  Userdetails? userDetails;

  FindUserByPhoneResponse({this.status, this.message, this.userDetails});

  FindUserByPhoneResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['details'] != null
        ? new Userdetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userDetails != null) {
      data['details'] = this.userDetails!.toJson();
    }
    return data;
  }
}
