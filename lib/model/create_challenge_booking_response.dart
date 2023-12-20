import 'package:cme/model/fetch_challenge_booking_response.dart';

class CreateChallengeBookingResponse {
  bool? status;
  String? message;
  ChallengeBookingDetails? details;

  CreateChallengeBookingResponse({this.status, this.message, this.details});

  CreateChallengeBookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details =
        json['details'] != null ? new ChallengeBookingDetails.fromJson(json['details']) : null;
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

/*

class ChallengeBookingDetails {
  List player1Entry;
  List player2Entry;
  int id;
  String bookingDates;
  String bookingtime;
  String startTime;
  String endTime;
  int player1Id;
  String status;
  String player2Id;
  String lon;
  String lat;
  String location;
  String sessionmode;
  String tryout;
  String gameplay;
  String updatedAt;
  String createdAt;

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
      this.lon,
      this.lat,
      this.location,
      this.sessionmode,
      this.tryout,
      this.gameplay,
      this.updatedAt,
      this.createdAt});

  ChallengeBookingDetails.fromJson(Map<String, dynamic> json) {
    if (json['player1_entry'] != null) {
      player1Entry = [];
      json['player1_entry'].forEach((v) {
        player1Entry.add(v);
      });
    }
    if (json['player2_entry'] != null) {
      player2Entry = [];
      json['player2_entry'].forEach((v) {
        player2Entry.add(v);
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
    lon = json['lon'];
    lat = json['lat'];
    location = json['location'];
    sessionmode = json['sessionmode'];
    tryout = json['tryout'];
    gameplay = json['gameplay'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.player1Entry != null) {
      data['player1_entry'] = this.player1Entry.map((v) => v).toList();
    }
    if (this.player2Entry != null) {
      data['player2_entry'] = this.player2Entry.map((v) => v).toList();
    }
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
    data['tryout'] = this.tryout;
    data['gameplay'] = this.gameplay;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}


*/