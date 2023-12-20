import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:jiffy/jiffy.dart';

class FetchPlayerBuddyUpResponse {
  bool? status;
  String? message;
  List<BuddyUpBookingDetails>? details;

  FetchPlayerBuddyUpResponse({this.status, this.message, this.details});

  FetchPlayerBuddyUpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <BuddyUpBookingDetails>[];
      json['details'].forEach((v) {
        details!.add(new BuddyUpBookingDetails.fromJson(v));
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

class BuddyUpBookingDetails {
  int? id;
  String? bookingDates;
  String? bookingtime;
  dynamic startTime;
  dynamic endTime;
  int? player1Id;
  String? status;
  int? player2Id;
  dynamic lon;
  dynamic lat;
  String? location;
  int? sessionmode;
  String? nok;

  String? displayDate;
  DateTime? startDateTime;
  String? nokRelationship;
  String? nokPhone;
  String? healthstatus;
  String? videotoken;
  String? virtualstatus;
  String? createdAt;
  String? sport;
  String? updatedAt;
  Userdetails? player1User;
  Userdetails? player2User;
  Profiledetails? player1Profile;
  Profiledetails? player2Profile;

  BuddyUpBookingDetails(
      {this.id,
      this.bookingDates,
      this.bookingtime,
      this.startTime,
      this.endTime,
      this.sport,
      this.player1Id,
      this.status,
      this.player2Id,
      this.lon,
      this.lat,
      this.location,
      this.sessionmode,
      this.nok,
      this.nokRelationship,
      this.nokPhone,
      this.healthstatus,
      this.videotoken,
      this.virtualstatus,
      this.createdAt,
      this.updatedAt,
      this.player1User,
      this.player2User,
      this.player1Profile,
      this.player2Profile});

  BuddyUpBookingDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingDates = json['bookingDates'];
    bookingtime = json['bookingtime'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    player1Id = json['player1_id'];
    status = json['status'];
    sport = json['sport'];
    player2Id = json['player2_id'];
    lon = json['lon'];
    lat = json['lat'];
    location = json['location'];
    sessionmode = json['sessionmode'];
    nok = json['nok'];
    nokRelationship = json['nokRelationship'];
    nokPhone = json['nokPhone'];
    healthstatus = json['healthstatus'];
    videotoken = json['videotoken'];
    virtualstatus = json['virtualstatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    player1User = json['player1_user'] != null
        ? new Userdetails.fromJson(json['player1_user'])
        : null;
    player2User = json['player2_user'] != null
        ? new Userdetails.fromJson(json['player2_user'])
        : null;
    player1Profile = json['player1_profile'] != null
        ? new Profiledetails.fromJson(json['player1_profile'])
        : null;
    player2Profile = json['player2_profile'] != null
        ? new Profiledetails.fromJson(json['player2_profile'])
        : null;

    startDateTime = bookingTimeStringToDateTime(bookingDates!, "$startTime");

    if (startDateTime!.day == DateTime.now().day) {
      displayDate = "Today, " + Jiffy(startDateTime).format("hh:mma");
    } else {
      displayDate = Jiffy(startDateTime).format("hh:mma MMM dd, yyyy");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingDates'] = this.bookingDates;
    data['bookingtime'] = this.bookingtime;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['player1_id'] = this.player1Id;
    data['status'] = this.status;
    data['sport'] = this.sport;
    data['player2_id'] = this.player2Id;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['location'] = this.location;
    data['sessionmode'] = this.sessionmode;
    data['nok'] = this.nok;
    data['nokRelationship'] = this.nokRelationship;
    data['nokPhone'] = this.nokPhone;
    data['healthstatus'] = this.healthstatus;
    data['videotoken'] = this.videotoken;
    data['virtualstatus'] = this.virtualstatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.player1User != null) {
      data['player1_user'] = this.player1User!.toJson();
    }
    if (this.player2User != null) {
      data['player2_user'] = this.player2User!.toJson();
    }
    if (this.player1Profile != null) {
      data['player1_profile'] = this.player1Profile!.toJson();
    }
    if (this.player2Profile != null) {
      data['player2_profile'] = this.player2Profile!.toJson();
    }
    return data;
  }
}
