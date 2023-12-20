class CreateBookingResponse {
  bool? status;
  String? message;
  List<Details>? details;
  Payment? payment;

  CreateBookingResponse(
      {this.status, this.message, this.details, this.payment});

  CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['rstatus'];
    message = json['message'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rstatus'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    return data;
  }
}

class Details {
  List<Otheruser>? otheruser;
  List? coachnote;
  int? id;
  String? bookingDates;
  int? userid;
  String? status;
  String? coachId;
  dynamic lon;
  dynamic lat;
  dynamic bookingtime;
  String? nok;
  String? nokRelationship;
  String? nokPhone;
  String? healthstatus;
  String? sessionmode;
  dynamic price;
  String? updatedAt;
  String? createdAt;

  Details(
      {this.otheruser,
      this.coachnote,
      this.id,
      this.bookingDates,
      this.userid,
      this.status,
      this.coachId,
      this.lon,
      this.lat,
      this.bookingtime,
      this.nok,
      this.nokRelationship,
      this.nokPhone,
      this.healthstatus,
      this.sessionmode,
      this.price,
      this.updatedAt,
      this.createdAt});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['otheruser'] != null) {
      otheruser = <Otheruser>[];
      json['otheruser'].forEach((v) {
        otheruser!.add(new Otheruser.fromJson(v));
      });
    }
    if (json['coachnote'] != null) {
      coachnote = <Null>[];
      json['coachnote'].forEach((v) {
        coachnote!.add(v);
      });
    }
    id = json['id'];
    bookingDates = json['bookingDates'];
    userid = json['userid'];
    status = json['status'];
    coachId = json['coach_id'];
    lon = json['lon'];
    lat = json['lat'];
    bookingtime = json['bookingtime'];
    nok = json['nok'];
    nokRelationship = json['nokRelationship'];
    nokPhone = json['nokPhone'];
    healthstatus = json['healthstatus'];
    sessionmode = json['sessionmode'];
    price = json['price'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.otheruser != null) {
      data['otheruser'] = this.otheruser!.map((v) => v.toJson()).toList();
    }
    if (this.coachnote != null) {
      data['coachnote'] = this.coachnote!.map((v) => v).toList();
    }
    data['id'] = this.id;
    data['bookingDates'] = this.bookingDates;
    data['userid'] = this.userid;
    data['status'] = this.status;
    data['coach_id'] = this.coachId;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['bookingtime'] = this.bookingtime;
    data['nok'] = this.nok;
    data['nokRelationship'] = this.nokRelationship;
    data['nokPhone'] = this.nokPhone;
    data['healthstatus'] = this.healthstatus;
    data['sessionmode'] = this.sessionmode;
    data['price'] = this.price;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
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

class Payment {
  int? id;
  int? userid;
  String? ref;
  String? paymentTitle;
  String? paymentType;
  String? amount;
  int? bookingID;
  String? bookingType;
  String? paymentOption;
  String? paymentOptionID;
  String? updatedAt;
  String? createdAt;

  Payment(
      {this.id,
      this.userid,
      this.ref,
      this.paymentTitle,
      this.paymentType,
      this.amount,
      this.bookingID,
      this.bookingType,
      this.paymentOption,
      this.paymentOptionID,
      this.updatedAt,
      this.createdAt});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    ref = json['ref'];
    paymentTitle = json['paymentTitle'];
    paymentType = json['paymentType'];
    amount = json['amount'];
    bookingID = json['bookingID'];
    bookingType = json['bookingType'];
    paymentOption = json['paymentOption'];
    paymentOptionID = json['paymentOptionID'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['ref'] = this.ref;
    data['paymentTitle'] = this.paymentTitle;
    data['paymentType'] = this.paymentType;
    data['amount'] = this.amount;
    data['bookingID'] = this.bookingID;
    data['bookingType'] = this.bookingType;
    data['paymentOption'] = this.paymentOption;
    data['paymentOptionID'] = this.paymentOptionID;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
