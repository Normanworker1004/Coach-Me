import 'package:cme/model/user_class/user_details.dart';

class FilterContactResponse {
  bool? status;
  String? message;
  List<Userdetails>? details;

  FilterContactResponse({this.status, this.message, this.details});

  FilterContactResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <Userdetails>[];
      json['details'].forEach((v) {
        details!.add(new Userdetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
