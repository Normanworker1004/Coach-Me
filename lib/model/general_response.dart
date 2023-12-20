import 'package:cme/model/user_class/user_details.dart';

class GeneralResponse {
  bool? status;
  String? message;

  GeneralResponse({this.status, this.message});

  GeneralResponse.fromJson(Map<String, dynamic> json) {
    status = json['rstatus'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rstatus'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class GeneralResponse2 {
  bool? status;
  String? message;
  Userdetails? userDetails;

  GeneralResponse2({this.status, this.message});

  GeneralResponse2.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['details'] != null && !(json['details'] is List)
        ? new Userdetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['message'] = this.userDetails;
    
    return data;
  }
}
