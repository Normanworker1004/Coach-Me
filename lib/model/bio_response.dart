import 'package:cme/model/user_class/profile_details.dart';

class BioResponse {
  bool? status;
  String? description;
  Profiledetails? profile;

  BioResponse({this.status, this.description, this.profile});

  BioResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    profile = json['Profile'] != null
        ? new Profiledetails.fromJson(json['Profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.profile != null) {
      data['Profile'] = this.profile!.toJson();
    }
    return data;
  }
}
