class CoachBookingNoteResponse {
  bool? status;
  String? message;
  Details? details;

  CoachBookingNoteResponse({this.status, this.message, this.details});

  CoachBookingNoteResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  List? otheruser;
  List<Coachnote>? coachnote;
  int? id;
  String? bookingDates;
  int? userid;
  String? status;
  int? coachId;
  int? price;
  int? lon;
  int? lat;
  String? location;
  String? bookingtime;
  int? sessionmode;
  String? nok;
  String? nokRelationship;
  String? nokPhone;
  String? healthstatus;
  String? createdAt;
  String? updatedAt;

  Details(
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
      this.updatedAt});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['otheruser'] != null) {
      otheruser = [];
      json['otheruser'].forEach((v) {
        otheruser!.add((v));
      });
    }
    if (json['coachnote'] != null) {
      coachnote = <Coachnote>[];
      json['coachnote'].forEach((v) {
        coachnote!.add(new Coachnote.fromJson(v));
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.otheruser != null) {
      data['otheruser'] = this.otheruser!.map((v) => v).toList();
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Coachnote {
  String? date;
  String? note;

  Coachnote({this.date, this.note});

  Coachnote.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['note'] = this.note;
    return data;
  }
}
