import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:jiffy/jiffy.dart';

class CoachSessionResponse {
  bool? status;
  Message? message;

  CoachSessionResponse({this.status, this.message});

  CoachSessionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  List<Booking>? booking;
  List? bootcamp;
  int? totalbooking;

  Message({this.booking, this.bootcamp, this.totalbooking});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['booking'] != null) {
      booking = <Booking>[];
      json['booking'].forEach((v) {
        booking!.add(new Booking.fromJson(v));
      });
    }
    if (json['bootcamp'] != null) {
      bootcamp = <Null>[];
      json['bootcamp'].forEach((v) {
        bootcamp!.add(v);
      });
    }
    totalbooking = json['totalbooking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booking != null) {
      data['booking'] = this.booking!.map((v) => v.toJson()).toList();
    }
    if (this.bootcamp != null) {
      data['bootcamp'] = this.bootcamp!.map((v) => v.toJson()).toList();
    }
    data['totalbooking'] = this.totalbooking;
    return data;
  }
}

class Booking {
  List? otheruser;
  List? coachnote;
  int? id;
  String? bookingDates;
  int? userid;
  String? status;
  int? coachId;
  dynamic price;
  dynamic lon;
  dynamic lat;
  String? location;
  String? bookingtime;
  int? sessionmode;
  String? displayDate;
  DateTime? startDateTime;
  String? nok;
  String? nokRelationship;
  String? nokPhone;
  String? healthstatus;
  String? createdAt;
  String? updatedAt;
  Userdetails? user;

  Booking(
      {this.otheruser,
      this.coachnote,
      this.id,
      this.bookingDates,
      this.userid,
      this.status,
      this.coachId,
      this.price,
      this.lon,
      this.lat,
      this.location,
      this.bookingtime,
      this.sessionmode,
      this.nok,
      this.nokRelationship,
      this.nokPhone,
      this.healthstatus,
      this.createdAt,
      this.updatedAt,
      this.user});

  Booking.fromJson(Map<String, dynamic> json) {
    if (json['otheruser'] != null) {
      otheruser = <Null>[];
      json['otheruser'].forEach((v) {
        otheruser!.add(v);
      });
    }
    if (json['coachnote'] != null) {
      coachnote = [];
      json['coachnote'].forEach((v) {
        coachnote!.add(v);
      });
    }
    id = json['id'];
    bookingDates = json['bookingDates'];
    userid = json['userid'];
    status = json['status'];
    coachId = json['coach_id'];
    price = json['price'];
    lon = json['lon'];
    lat = json['lat'];
    location = json['location'];
    bookingtime = json['bookingtime'];
    sessionmode = json['sessionmode'];
    nok = json['nok'];
    nokRelationship = json['nokRelationship'];
    nokPhone = json['nokPhone'];
    healthstatus = json['healthstatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['user'] != null) {
      user = new Userdetails.fromJson(json['user']);
    } else {
      user = null;
    }
     startDateTime = coachBookingTimeStringToDateTime(
      bookingDates!,
      bookingtime!.split(":").first,
    );

    if (startDateTime!.isAfter(DateTime.now().add(Duration(hours: 24)))) {
      displayDate = Jiffy(startDateTime).format("hh:mma MMM dd, yyyy");
    } else {
      displayDate = "Today, " + Jiffy(startDateTime).format("hh:mma");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.otheruser != null) {
      data['otheruser'] = this.otheruser!.map((v) => v).toList();
    }
    if (this.coachnote != null) {
      data['coachnote'] = this.coachnote!.map((v) => v).toList();
    }
    data['id'] = this.id;
    data['bookingDates'] = this.bookingDates;
    data['userid'] = this.userid;
    data['status'] = this.status;
    data['coach_id'] = this.coachId;
    data['price'] = this.price;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['location'] = this.location;
    data['bookingtime'] = this.bookingtime;
    data['sessionmode'] = this.sessionmode;
    data['nok'] = this.nok;
    data['nokRelationship'] = this.nokRelationship;
    data['nokPhone'] = this.nokPhone;
    data['healthstatus'] = this.healthstatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
