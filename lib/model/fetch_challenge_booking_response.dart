import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:jiffy/jiffy.dart';

class FetchChallengeBookingResponse {
  bool? status;
  String? message;
  List<ChallengeBookingDetails>? details;

  FetchChallengeBookingResponse({this.status, this.message, this.details});

  FetchChallengeBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <ChallengeBookingDetails>[];
      json['details'].forEach((v) {
        details!.add(new ChallengeBookingDetails.fromJson(v));
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

class ChallengeBookingDetails {
  List? player1Entry;
  List? player2Entry;
  int? id;
  String? bookingDates;
  String? bookingtime;

  String? displayDate;
  DateTime? startDateTime;
  int? startTime;
  int? endTime;
  int? player1Id;
  String? status;
  int? player2Id;
  int? tryout;
  String? gameplay;
  dynamic winStatus1;
  dynamic winStatus2;
  dynamic lon;
  dynamic lat;
  String? location;
  int? sessionmode;
  String? nok;
  String? nokRelationship;
  String? nokPhone;
  String? healthstatus;
  String? videotoken;
  String? virtualstatus;
  String? createdAt;
  String? updatedAt;
  Userdetails? player1Details;
  Userdetails? player2Details;
  Profiledetails? player1Profile;
  Profiledetails? player2Profile;

  ChallengeBookingDetails(
      {this.player1Entry,
      this.player2Entry,
      this.id,
      this.bookingDates,
      this.bookingtime,
      this.startTime,
      this.endTime,
      this.player1Id,
      this.status,
      this.player2Id,
      this.tryout,
      this.gameplay,
      this.winStatus1,
      this.winStatus2,
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
      this.player1Details,
      this.player2Details,
      this.player1Profile,
      this.player2Profile});

  ChallengeBookingDetails.fromJson(Map<String, dynamic> json) {
    print("passed....");
    if (json['player1_entry'] != null) {
      player1Entry = [];
      json['player1_entry'].forEach((v) {
        player1Entry!.add(v);
      });
    }
    if (json['player2_entry'] != null) {
      player2Entry = [];
      json['player2_entry'].forEach((v) {
        player2Entry!.add(v);
      });
    }
    id = json['id'];
    bookingDates = json['bookingDates'];
    bookingtime = json['bookingtime'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    player1Id = json['player1_id'];
    status = json['status'];
    player2Id = json['player2_id'];
    tryout = json['tryout'];
    gameplay = json['gameplay'];
    winStatus1 = json['win_status1'];
    winStatus2 = json['win_status2'];
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
    player1Details = json['player1_user'] != null
        ? new Userdetails.fromJson(json['player1_user'])
        : null;
    player2Details = json['player2_user'] != null
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
    if (this.player1Entry != null) {
      data['player1_entry'] = this.player1Entry!.map((v) => v).toList();
    }
    if (this.player2Entry != null) {
      data['player2_entry'] = this.player2Entry!.map((v) => v).toList();
    }
    data['id'] = this.id;
    data['bookingDates'] = this.bookingDates;
    data['bookingtime'] = this.bookingtime;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['player1_id'] = this.player1Id;
    data['status'] = this.status;
    data['player2_id'] = this.player2Id;
    data['tryout'] = this.tryout;
    data['gameplay'] = this.gameplay;
    data['win_status1'] = this.winStatus1;
    data['win_status2'] = this.winStatus2;
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
    if (this.player1Details != null) {
      data['player1_user'] = this.player1Details!.toJson();
    }
    if (this.player2Details != null) {
      data['player2_user'] = this.player2Details!.toJson();
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
