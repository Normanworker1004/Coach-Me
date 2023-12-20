import 'package:cme/model/map_bootcamp_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:jiffy/jiffy.dart';

class FetchPlayerHomeBookingResponse {
  bool? status;
  String? message;
  List<PlayerHomeBookingDetails>? details;
  List<PlayerStatisticsItem>? statsData;

  FetchPlayerHomeBookingResponse({this.status, this.message, this.details});

  FetchPlayerHomeBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <PlayerHomeBookingDetails>[];
      json['details'].forEach((v) {

        PlayerHomeBookingDetails playerHomeBookingDetails = PlayerHomeBookingDetails.fromJson(v);
        // if(playerHomeBookingDetails.data?.status == "accepted" || playerHomeBookingDetails.bookingtype == "bootcamp")
          details!.add(playerHomeBookingDetails);
      });
    }

    if (json['playerstatistics'] != null) {
      statsData = <PlayerStatisticsItem>[];
      json['playerstatistics'].forEach((v) {
        statsData!.add(PlayerStatisticsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerStatisticsItem {
  int? id;
  int? userid;
  int? target;
  String? goal;
  String? category;
  String? createdAt;
  String? updatedAt;
  List<PlayerStatisticsData>? playerstatistics;

  PlayerStatisticsItem(
      {this.id,
      this.userid,
      this.target,
      this.goal,
      this.category,
      this.createdAt,
      this.updatedAt,
      this.playerstatistics});

  PlayerStatisticsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    target = json['target'];
    goal = json['goal'];
    category = json['category'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['playerstatistics'] != null) {
      playerstatistics = <PlayerStatisticsData>[];
      json['playerstatistics'].forEach((v) {
        playerstatistics!.add(new PlayerStatisticsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['target'] = this.target;
    data['goal'] = this.goal;
    data['category'] = this.category;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.playerstatistics != null) {
      data['playerstatistics'] =
          this.playerstatistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerStatisticsData {
  int? id;
  int? statloc;
  int? mydata;
  String? createdAt;
  String? updatedAt;

  PlayerStatisticsData(
      {this.id, this.statloc, this.mydata, this.createdAt, this.updatedAt});

  PlayerStatisticsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statloc = json['statloc'];
    mydata = json['mydata'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statloc'] = this.statloc;
    data['mydata'] = this.mydata;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class PlayerHomeBookingDetails {
  Data? data;
  String? bookingtype;
  String? startTime;

  PlayerHomeBookingDetails({this.data, this.bookingtype, this.startTime});

  PlayerHomeBookingDetails.fromJson(Map<String, dynamic> json) {
    bookingtype = json['bookingtype'];
    // print("$bookingtype................");
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['bookingtype'] = this.bookingtype;
    data['start_time'] = this.startTime;
    return data;
  }
}

class Data {
  List? player1ChallengeEntry;
  List? player2ChallengeEntry;
  int? id;
  String? bookingDates;
  String? bookingtime;
  String? sport;
  int? startTime;
  int? endTime;
  int? player1Id;
  dynamic status;
  int? player2Id;
  dynamic tryout;
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
  dynamic videotoken;
  String? virtualstatus;
  String? createdAt;
  String? updatedAt;
  Userdetails? player1Details;
  Userdetails? player2Details;
  Profiledetails? player1Profile;
  Profiledetails? player2Profile;
  String? bootCampDate;
  int? bootcampID;
  int? userid;
  int? coachId;
  Userdetails? coachinfo;
  Profiledetails? coachprofile;
  BootCampDetails? bootCampDetails;

  String displayDate = "Not Set";
  DateTime? startDateTime;

  Data(
      {this.player1ChallengeEntry,
      this.player2ChallengeEntry,
      this.id,
      this.bookingDates,
      this.bookingtime,
      this.sport,
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
      this.player2Profile,
      this.bootCampDate,
      this.bootcampID,
      this.userid,
      this.coachId,
      this.coachinfo,
      this.bootCampDetails,
      this.coachprofile});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['player1_entry'] != null) {
      player1ChallengeEntry = [];
      json['player1_entry'].forEach((v) {
        player1ChallengeEntry!.add(v);
      });
    }
    if (json['player2_entry'] != null) {
      player2ChallengeEntry = [];
      json['player2_entry'].forEach((v) {
        player2ChallengeEntry!.add(v);
      });
    }
    id = json['id'];
    bookingDates = json['bookingDates'];
    bookingtime = json['bookingtime'];
    sport = json['sport'];
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
        ? Userdetails.fromJson(json['player1_user'])
        : null;

    // print("player 1....${player1Details.id}");
    player2Details = json['player2_user'] != null
        ? Userdetails.fromJson(json['player2_user'])
        : null;
    // print("player 2....${player2Details.id}");
    player1Profile = json['player1_profile'] != null
        ? Profiledetails.fromJson(json['player1_profile'])
        : null;
    // print("player 3....${player1Profile.id}");
    player2Profile = json['player2_profile'] != null
        ? Profiledetails.fromJson(json['player2_profile'])
        : null;
    // print("player 4....${player2Profile.id}");
    bootCampDate = json['bootCampDate'];
    bootcampID = json['bootcampID'];
    userid = json['userid'];
    coachId = json['coach_id'];
    coachinfo = json['coachinfo'] != null
        ? Userdetails.fromJson(json['coachinfo'])
        : null;
    coachprofile = json['coachprofile'] != null
        ? Profiledetails.fromJson(json['coachprofile'])
        : null;
    bootCampDetails = json['bootcampdetails'] != null
        ? BootCampDetails.fromJson(json['bootcampdetails'])
        : null;

    try {
      startDateTime = bookingTimeStringToDateTime(bookingDates!, "$startTime");

      if (startDateTime!.day == DateTime.now().day) {
        displayDate = "Today, " + Jiffy(startDateTime).format("hh:mma");
      } else {
        displayDate = Jiffy(startDateTime).format("hh:mma MMM dd, yyyy");
      }
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.player1ChallengeEntry != null) {
      data['player1_entry'] =
          this.player1ChallengeEntry!.map((v) => v.toJson()).toList();
    }
    if (this.player2ChallengeEntry != null) {
      data['player2_entry'] =
          this.player2ChallengeEntry!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['bookingDates'] = this.bookingDates;
    data['bookingtime'] = this.bookingtime;
    data['sport'] = this.sport;
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
    data['bootCampDate'] = this.bootCampDate;
    data['bootcampID'] = this.bootcampID;
    data['userid'] = this.userid;
    data['coach_id'] = this.coachId;
    if (this.coachinfo != null) {
      data['coachinfo'] = this.coachinfo!.toJson();
    }
    if (this.coachprofile != null) {
      data['coachprofile'] = this.coachprofile!.toJson();
    }
    return data;
  }
}
