import 'package:cme/model/user_class/user_details.dart';

class FetchFixturesLeaderBoardResponse {
  bool? status;
  String? message;
  ResponseData? responseData;
  List<FixturesDetails>? details;

  FetchFixturesLeaderBoardResponse(
      {this.status, this.message, this.responseData, this.details});

  FetchFixturesLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseData = json['response_data'] != null
        ? new ResponseData.fromJson(json['response_data'])
        : null;
    if (json['details'] != null) {
      details = <FixturesDetails>[];
      json['details'].forEach((v) {
        details!.add(new FixturesDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.responseData != null) {
      data['response_data'] = this.responseData!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  bool? status;
  String? message;
  int? result;
  FixturesUserdata? userdata;

  ResponseData({this.status, this.message, this.result, this.userdata});

  ResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'];
    userdata = json['userdata'] != null
        ? new FixturesUserdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['result'] = this.result;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    return data;
  }
}

class FixturesUserdata {
  int? userid;
  int? cnt;

  FixturesUserdata({this.userid, this.cnt});

  FixturesUserdata.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['cnt'] = this.cnt;
    return data;
  }
}

class FixturesDetails {
  int? userid;
  dynamic score1;
  dynamic score2;
  dynamic score3;
  dynamic score4;
  int? cnt;
  Userdetails? fixtureuserdetails;

  FixturesDetails(
      {this.userid,
      this.score1,
      this.score2,
      this.score3,
      this.score4,
      this.cnt,
      this.fixtureuserdetails});

  FixturesDetails.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    score1 = json['score1'];
    score2 = json['score2'];
    score3 = json['score3'];
    score4 = json['score4'];
    cnt = json['cnt'];
    fixtureuserdetails = json['fixtureuserdetails'] != null
        ? new Userdetails.fromJson(json['fixtureuserdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['score1'] = this.score1;
    data['score2'] = this.score2;
    data['score3'] = this.score3;
    data['score4'] = this.score4;
    data['cnt'] = this.cnt;
    if (this.fixtureuserdetails != null) {
      data['fixtureuserdetails'] = this.fixtureuserdetails!.toJson();
    }
    return data;
  }
}
