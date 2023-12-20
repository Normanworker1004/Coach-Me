import 'package:cme/model/user_class/user_details.dart';

class UserUpdate {
  bool? status;
  String? message;
  Userdetails? details;

  UserUpdate({this.status, this.message, this.details});

  UserUpdate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details = json['details'] != null
        ? new Userdetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}
