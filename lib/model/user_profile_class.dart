import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';

class UserProfile {
  bool? status;
  Message? message;

  UserProfile({this.status, this.message});

  UserProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  Userdetails? userdetails;
  Profiledetails? profiledetails;

  Message({this.userdetails, this.profiledetails});

  Message.fromJson(Map<String, dynamic> json) {
    userdetails = json['userdetails'] != null
        ? new Userdetails.fromJson(json['userdetails'])
        : null;
    profiledetails = json['profiledetails'] != null
        ? new Profiledetails.fromJson(json['profiledetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userdetails != null) {
      data['userdetails'] = this.userdetails!.toJson();
    }
    if (this.profiledetails != null) {
      data['profiledetails'] = this.profiledetails!.toJson();
    }
    return data;
  }
}
