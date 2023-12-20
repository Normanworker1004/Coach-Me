class BootCampClass {
  bool? status;
  String? message;
  List<Details>? details;

  BootCampClass({this.status, this.message, this.details});

  BootCampClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }
}

class Details {
  List<Bootcamptime>? bootcamptime;
  List? bootcampPlayer;
  List? nok;
  List? nokRelationship;
  List? nokPhone;
  List? healthstatus;
  int? id;
  String? bootCampDate;
  String? bootCampmonth;
  int? userid;
  dynamic price;
  String? description;
  String? location;
  dynamic lon;
  dynamic lat;
  int? capacity;
  String? createdAt;
  String? updatedAt;

  Details(
      {this.bootcamptime,
      this.bootcampPlayer,
      this.nok,
      this.nokRelationship,
      this.nokPhone,
      this.healthstatus,
      this.id,
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
      this.updatedAt});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['bootcamptime'] != null) {
      bootcamptime = <Bootcamptime>[];
      json['bootcamptime'].forEach((v) {
        bootcamptime!.add(new Bootcamptime.fromJson(v));
      });
    }

    // bootcampPlayer = json['bootcampPlayer'];
    // nok = json['nok'];
    // nokRelationship = json['nokRelationship'];
    // nokPhone = json['nokPhone'];
    // healthstatus = json['healthstatus'];

    if (json['bootcampPlayer'] != null) {
      bootcampPlayer = [];
      json['bootcampPlayer'].forEach((v) {
        bootcampPlayer!.add(v);
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
    bootCampDate = json['bootCampDate'];
    bootCampmonth = json['bootCampmonth'];
    userid = json['userid'];
    price = json['price'];
    description = json['description'];
    location = json['location'];

    try {
      lon = json['lon'] as double?;
      lat = json['lat'] as double?;
      capacity = json['capacity'] as int?;
    } catch (e) {}
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bootcamptime != null) {
      data['bootcamptime'] = this.bootcamptime!.map((v) => v.toJson()).toList();
    }
    data['bootcampPlayer'] = this.bootcampPlayer;
    data['nok'] = this.nok;
    data['nokRelationship'] = this.nokRelationship;
    data['nokPhone'] = this.nokPhone;
    data['healthstatus'] = this.healthstatus;
    data['id'] = this.id;
    data['bootCampDate'] = this.bootCampDate;
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
    return data;
  }
}

class Bootcamptime {
  String? time;

  Bootcamptime({this.time});

  Bootcamptime.fromJson(Map<String, dynamic> json) {
    try {
      time = json['time'];
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\"time\"'] = "\"${this.time}\"";
    return data;
  }
}
