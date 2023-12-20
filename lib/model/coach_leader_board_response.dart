import 'package:cme/model/user_class/user_details.dart';

class CoachLeaderBoardResponse {
  bool? status;
  String? message;
  CoachPositionData? coachPositionData;
  List<LeagueSubDetails>? details;

  CoachLeaderBoardResponse(
      {this.status, this.message, this.coachPositionData, this.details});

  CoachLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    coachPositionData = json['response_data'] != null
        ? new CoachPositionData.fromJson(json['response_data'])
        : null;
    if (json['details'] != null) {
      details = <LeagueSubDetails>[];
      json['details'].forEach((v) {
        details!.add(new LeagueSubDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.coachPositionData != null) {
      data['response_data'] = this.coachPositionData!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoachPositionData {
  bool? coachFound;
  String? message;
  int? myPosition;
  Userdata? userdata;

  CoachPositionData(
      {this.coachFound, this.message, this.myPosition, this.userdata});

  CoachPositionData.fromJson(Map<String, dynamic> json) {
    coachFound = json['status'];
    message = json['message'];
    myPosition = json['result'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.coachFound;
    data['message'] = this.message;
    data['result'] = this.myPosition;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    return data;
  }
}

class Userdata {
  int? userId;
  int? exRating;
  int? exSession;
  int? exPoints;
  int? exAppusagePt;
  String? cnt;

  Userdata(
      {this.userId,
      this.exRating,
      this.exSession,
      this.exPoints,
      this.exAppusagePt,
      this.cnt});

  Userdata.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    exRating = json['ex_rating'];
    exSession = json['ex_session'];
    exPoints = json['ex_points'];
    exAppusagePt = json['ex_appusage_pt'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['ex_rating'] = this.exRating;
    data['ex_session'] = this.exSession;
    data['ex_points'] = this.exPoints;
    data['ex_appusage_pt'] = this.exAppusagePt;
    data['cnt'] = this.cnt;
    return data;
  }
}

class LeagueSubDetails {
  int? exRating;
  int? exSession;
  int? exPoints;
  int? exAppusagePt;
  String? cnt;
  Userdetails? userdetails;

  LeagueSubDetails(
      {this.exRating,
      this.exSession,
      this.exPoints,
      this.exAppusagePt,
      this.cnt,
      this.userdetails});

  LeagueSubDetails.fromJson(Map<String, dynamic> json) {
    exRating = json['ex_rating'];
    exSession = json['ex_session'];
    exPoints = json['ex_points'];
    exAppusagePt = json['ex_appusage_pt'];
    cnt = json['cnt'];
    userdetails = json['userdetails'] != null
        ? new Userdetails.fromJson(json['userdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ex_rating'] = this.exRating;
    data['ex_session'] = this.exSession;
    data['ex_points'] = this.exPoints;
    data['ex_appusage_pt'] = this.exAppusagePt;
    data['cnt'] = this.cnt;
    if (this.userdetails != null) {
      data['userdetails'] = this.userdetails!.toJson();
    }
    return data;
  }
}
