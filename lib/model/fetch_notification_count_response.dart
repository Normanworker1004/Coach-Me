class FetchNotificationsCountResponse {
  bool? status;
  String? message;
  int? count;

  FetchNotificationsCountResponse({this.status, this.message, this.count});

  FetchNotificationsCountResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['count'] != null) {
      count = json['count'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    return data;
  }
}


