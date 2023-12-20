import 'package:cme/model/coach_booking_note_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:jiffy/jiffy.dart';

class FetchPlayerBookingResponse {
  bool? status;
  String? message;
  List<BookingDetails>? details;

  FetchPlayerBookingResponse({this.status: false, this.message, this.details});

  FetchPlayerBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <BookingDetails>[];
      json['details'].forEach((v) {
        details!.add(new BookingDetails.fromJson(v));
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

class BookingDetails {
  List<Otheruser>? otheruser;
  List<Coachnote>? coachnote;
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
  String? nok;
  String? nokRelationship;
  String? nokPhone;
  String? healthstatus;
  String? videotoken;
  String? virtualstatus;
  String? createdAt;
  String? updatedAt;

  String? displayDate;
  DateTime? startDateTime;
  Userdetails? coachinfo;

  BookingDetails(
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
      this.videotoken,
      this.virtualstatus,
      this.createdAt,
      this.updatedAt,
      this.coachinfo});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    if (json['otheruser'] != null) {
      otheruser = <Otheruser>[];
      json['otheruser'].forEach((v) {
        otheruser!.add(new Otheruser.fromJson(v));
      });
    }
    if (json['coachnote'] != null) {
      coachnote = <Coachnote>[];
      json['coachnote'].forEach((v) {
        coachnote!.add(Coachnote.fromJson(v));
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
    location = json['location'] ?? "Not set";
    bookingtime = json['bookingtime'];
    sessionmode = json['sessionmode'];
    nok = json['nok'];
    nokRelationship = json['nokRelationship'];
    nokPhone = json['nokPhone'];
    healthstatus = json['healthstatus'];
    videotoken = json['videotoken'];
    virtualstatus = json['virtualstatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    coachinfo = json['coachinfo'] != null
        ? Userdetails.fromJson(json['coachinfo'])
        : null;

    startDateTime = coachBookingTimeStringToDateTime(
      bookingDates!,
      bookingtime!.split(":").first,
    );

    if (startDateTime!.isAfter(DateTime.now().add(Duration(hours: 24)))) {
      displayDate = Jiffy(startDateTime).format("hh:mma MMM dd, yyyy");
    } else {
      displayDate = Jiffy(startDateTime).format("MMM do yyyy")+", " + Jiffy(startDateTime).format("hh:mma");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.otheruser != null) {
      data['otheruser'] = this.otheruser!.map((v) => v.toJson()).toList();
    }
    if (this.coachnote != null) {
      data['coachnote'] = this.coachnote!.map((v) => v.toJson()).toList();
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
    data['videotoken'] = this.videotoken;
    data['virtualstatus'] = this.virtualstatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.coachinfo != null) {
      data['coachinfo'] = this.coachinfo!.toJson();
    }
    return data;
  }
}

class Otheruser {
  String? phone;

  Otheruser({this.phone});

  Otheruser.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    return data;
  }
}
