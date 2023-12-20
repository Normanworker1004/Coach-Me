import 'package:cme/model/map_bootcamp_response.dart';

class FetchPlayerBootCampListResponse {
  bool? status;
  String? message;
  List<BCDetails>? details;

  FetchPlayerBootCampListResponse({this.status, this.message, this.details});

  FetchPlayerBootCampListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <BCDetails>[];
      json['details'].forEach((v) {
        details!.add(new BCDetails.fromJson(v));
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

class BCDetails {
  dynamic healthstatus;
  int? id;
  String? bootCampDate;
  int? bootcampID;
  int? userid;
  int? coachId;
  dynamic nok;
  dynamic nokRelationship;
  dynamic nokPhone;
  String? createdAt;
  String? updatedAt;
  BootCampDetails? bootcampdetails;

  BCDetails(
      {this.healthstatus,
      this.id,
      this.bootCampDate,
      this.bootcampID,
      this.userid,
      this.coachId,
      this.nok,
      this.nokRelationship,
      this.nokPhone,
      this.createdAt,
      this.updatedAt,
      this.bootcampdetails});

  BCDetails.fromJson(Map<String, dynamic> json) {
    healthstatus = json['healthstatus'];
    id = json['id'];
    bootCampDate = json['bootCampDate'];
    bootcampID = json['bootcampID'];
    userid = json['userid'];
    coachId = json['coach_id'];
    nok = json['nok'];
    nokRelationship = json['nokRelationship'];
    nokPhone = json['nokPhone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bootcampdetails = json['bootcampdetails'] != null
        ? new BootCampDetails.fromJson(json['bootcampdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthstatus'] = this.healthstatus;
    data['id'] = this.id;
    data['bootCampDate'] = this.bootCampDate;
    data['bootcampID'] = this.bootcampID;
    data['userid'] = this.userid;
    data['coach_id'] = this.coachId;
    data['nok'] = this.nok;
    data['nokRelationship'] = this.nokRelationship;
    data['nokPhone'] = this.nokPhone;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.bootcampdetails != null) {
      data['bootcampdetails'] = this.bootcampdetails!.toJson();
    }
    return data;
  }
}
