class CreateBuddyBookingResponse {
  bool? status;
  String? message;
  Details? details;

  CreateBuddyBookingResponse({this.status, this.message, this.details});

  CreateBuddyBookingResponse.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? bookingDates;
  String? bookingtime;
  String? startTime;
  String? endTime;
  int? player1Id;
  String? status;
  String? player2Id;
  String? lon;
  String? lat;
  String? location;
  String? sessionmode;
  String? updatedAt;
  String? createdAt;

  Details(
      {this.id,
      this.bookingDates,
      this.bookingtime,
      this.startTime,
      this.endTime,
      this.player1Id,
      this.status,
      this.player2Id,
      this.lon,
      this.lat,
      this.location,
      this.sessionmode,
      this.updatedAt,
      this.createdAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingDates = json['bookingDates'];
    bookingtime = json['bookingtime'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    player1Id = json['player1_id'];
    status = json['status'];
    player2Id = json['player2_id'];
    lon = json['lon'];
    lat = json['lat'];
    location = json['location'];
    sessionmode = json['sessionmode'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
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
    data['player2_id'] = this.player2Id;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['location'] = this.location;
    data['sessionmode'] = this.sessionmode;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
