import 'package:cme/model/user_class/user_details.dart';

class BuddyUpResponse {
  bool? status;
  String? message;
  List<Userdetails>? playerDetails;

  BuddyUpResponse({this.status, this.message, this.playerDetails});

  BuddyUpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      playerDetails = <Userdetails>[];
      json['details'].forEach((v) {
        playerDetails!.add(new Userdetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.playerDetails != null) {
      data['details'] = this.playerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
