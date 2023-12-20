import 'package:cme/model/map_bootcamp_response.dart';

class FetchCoachBootCampResponse {
  bool? status;
  String? message;
  List<BootCampDetails>? details;

  FetchCoachBootCampResponse({this.status, this.message, this.details});

  FetchCoachBootCampResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <BootCampDetails>[];
      json['details'].forEach((v) {
        details!.add(new BootCampDetails.fromJson(v));
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
