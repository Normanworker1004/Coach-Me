class FetchDiaryUnAvailabilityResponse {
  bool? status;
  String? message;
  List<DiaryDetails>? details;

  FetchDiaryUnAvailabilityResponse({this.status, this.message, this.details});

  FetchDiaryUnAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <DiaryDetails>[];
      json['details'].forEach((v) {
        details!.add(new DiaryDetails.fromJson(v));
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

class DiaryDetails {
  int? id;
  int? userid;
  String? booking;
  int? bookingid;
  String? unavailablestart;
  String? unavailableend;
  String? availableType;
  String? timingstart;
  String? timingend;
  String? createdAt;
  String? updatedAt;

  DiaryDetails(
      {this.id,
      this.userid,
      this.booking,
      this.bookingid,
      this.unavailablestart,
      this.unavailableend,
      this.availableType,
      this.timingstart,
      this.timingend,
      this.createdAt,
      this.updatedAt});

  DiaryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    booking = json['booking'];
    bookingid = json['bookingid'];
    unavailablestart = json['unavailablestart'];
    unavailableend = json['unavailableend'];
    availableType = json['available_type'];
    timingstart = json['timingstart'];
    timingend = json['timingend'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['booking'] = this.booking;
    data['bookingid'] = this.bookingid;
    data['unavailablestart'] = this.unavailablestart;
    data['unavailableend'] = this.unavailableend;
    data['available_type'] = this.availableType;
    data['timingstart'] = this.timingstart;
    data['timingend'] = this.timingend;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
