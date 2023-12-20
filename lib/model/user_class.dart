import 'package:cme/model/user_class/user_details.dart';

class UserClass {
  bool? status;
  String? message;
  Userdetails? details;
  String? token;

  UserClass({this.status, this.message, this.details, this.token});

  UserClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details = json['details'] != null
        ? new Userdetails.fromJson(json['details'])
        : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}
