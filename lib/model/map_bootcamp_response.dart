import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';

class MapBootCampResponse {
  bool? status;
  String? message;
  List<BootCampDetails>? details;

  MapBootCampResponse({this.status, this.message, this.details});

  MapBootCampResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // print("Completed......11111.");
    if (json['details'] != null) {
      details = <BootCampDetails>[];
      json['details'].forEach((v) {
        details!.add(new BootCampDetails.fromJson(v));
      });
    }

    // print("Completed......0000.");
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

class BootCampDetails {
  List<Bootcamptime>? bootcamptime;
  List<Userdetails>? bootcampPlayer;
  List? nok;
  List? nokRelationship;
  List? nokPhone;
  List? healthstatus;
  int? id;
  String? bootCampName;
  String? sport;
  String? bootCampDate;
  String? bootCampmonth;
  int? userid;
  double? price;
  String? description;
  String? location;
  dynamic lon;
  dynamic lat;
  int? capacity;
  String? createdAt;
  String? updatedAt;
  Userdetails? coachDetails;
  Profiledetails? coachProfile;
  List<JoinedBootCamp>? joinedbootcamp;

  BootCampDetails(
      {this.bootcamptime,
      this.bootcampPlayer,
      this.nok,
      this.nokRelationship,
      this.nokPhone,
      this.sport,
      this.healthstatus,
      this.id,
      this.bootCampName,
      this.bootCampDate,
      this.bootCampmonth,
      this.userid,
      this.price,
      this.description,
      this.location,
      this.lon,
      this.lat,
      this.capacity,
      this.createdAt,
      this.updatedAt,
      this.coachProfile,
      this.coachDetails});

  BootCampDetails.fromJson(Map<String, dynamic> json) {
    if (json['bootcamptime'] != null) {
      bootcamptime = <Bootcamptime>[];
      json['bootcamptime'].forEach((v) {
        bootcamptime!.add(new Bootcamptime.fromJson(v));
      });
    }
    if (json['bootcampPlayer'] != null) {
      bootcampPlayer = <Userdetails>[];
      json['bootcampPlayer'].forEach((v) {
        bootcampPlayer!.add(Userdetails.fromJson(v));
      });
    }
    if (json['nok'] != null) {
      nok = [];
      json['nok'].forEach((v) {
        nok!.add(v);
      });
    }
    if (json['nokRelationship'] != null) {
      nokRelationship = [];
      json['nokRelationship'].forEach((v) {
        nokRelationship!.add(v);
      });
    }
    if (json['nokPhone'] != null) {
      nokPhone = [];
      json['nokPhone'].forEach((v) {
        nokPhone!.add(v);
      });
    }
    if (json['healthstatus'] != null) {
      healthstatus = [];
      json['healthstatus'].forEach((v) {
        healthstatus!.add(v);
      });
    }
    id = json['id'];
    bootCampName = json['bootCampName'];
    sport = json['sport'];
    bootCampDate = json['bootCampDate'];
    bootCampmonth = json['bootCampmonth'];
    userid = json['userid'];
    price = (json['price'] is int ?  json['price'].toDouble() : json['price']);
    description = json['description'];
    location = json['location'];
    lon = json['lon'];
    lat = json['lat'];
    capacity = json['capacity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    coachDetails =
        json['user'] != null ? new Userdetails.fromJson(json['user']) : null;
    if (json['coachprofile'] != null) {
      // print("There is profile........");

      coachProfile = new Profiledetails.fromJson(json['coachprofile']);
    } else {
      coachProfile = null;
    }
    if (json['joinedbootcamp'] != null) {
      joinedbootcamp = <JoinedBootCamp>[];
      json['joinedbootcamp'].forEach((v) {
        joinedbootcamp!.add(new JoinedBootCamp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bootcamptime != null) {
      data['bootcamptime'] = this.bootcamptime!.map((v) => v.toJson()).toList();
    }
    if (this.bootcampPlayer != null) {
      data['bootcampPlayer'] =
          this.bootcampPlayer!.map((v) => v.toJson()).toList();
    }
    if (this.nok != null) {
      data['nok'] = this.nok!.map((v) => v.toJson()).toList();
    }
    if (this.nokRelationship != null) {
      data['nokRelationship'] =
          this.nokRelationship!.map((v) => v.toJson()).toList();
    }
    if (this.nokPhone != null) {
      data['nokPhone'] = this.nokPhone!.map((v) => v.toJson()).toList();
    }
    if (this.healthstatus != null) {
      data['healthstatus'] = this.healthstatus!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['bootCampName'] = this.bootCampName;
    data['bootCampDate'] = this.bootCampDate;
    data['sport'] = this.sport ?? "football";
    data['bootCampmonth'] = this.bootCampmonth;
    data['userid'] = this.userid;
    data['price'] = this.price;
    data['description'] = this.description;
    data['location'] = this.location;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['capacity'] = this.capacity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.coachDetails != null) {
      data['user'] = this.coachDetails!.toJson();
    }
    if (this.coachProfile != null) {
      data['coachprofile'] = this.coachProfile!.toJson();
    }
    if (this.joinedbootcamp != null) {
      data['joinedbootcamp'] =
          this.joinedbootcamp!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Bootcamptime {
  String? time;

  Bootcamptime({this.time});

  Bootcamptime.fromJson(Map<String, dynamic> json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    return data;
  }
}

class JoinedBootCamp {
  String? healthstatus;
  int? id;
  String? bootCampDate;
  int? bootcampID;
  int? userid;
  int? coachId;
  String? nok;
  String? nokRelationship;
  String? nokPhone;
  String? createdAt;
  String? updatedAt;
  Userdetails? playerinfo;

  JoinedBootCamp(
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
      this.playerinfo});

  JoinedBootCamp.fromJson(Map<String, dynamic> json) {
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
    playerinfo = json['playerinfo'] != null
        ? new Userdetails.fromJson(json['playerinfo'])
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
    if (this.playerinfo != null) {
      data['playerinfo'] = this.playerinfo!.toJson();
    }
    return data;
  }
}
