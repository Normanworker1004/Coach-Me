class FetchNotificationResponse {
  bool? status;
  String? message;
  List<NotificationDetails>? details;

  FetchNotificationResponse({this.status, this.message, this.details});

  FetchNotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <NotificationDetails>[];
      json['details'].forEach((v) {
        details!.add(new NotificationDetails.fromJson(v));
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

class NotificationDetails {
  int? id;
  int? userid;
  String? message;
  String? pics;
  String? notificationtype;
  String? createdAt;
  String? updatedAt;

  NotificationDetails(
      {this.id,
      this.userid,
      this.message,
      this.pics,
      this.notificationtype,
      this.createdAt,
      this.updatedAt});

  NotificationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    message = json['message'];
    pics = json['pics'];
    notificationtype = json['notificationtype'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['message'] = this.message;
    data['pics'] = this.pics;
    data['notificationtype'] = this.notificationtype;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

