class FeedbackResponse {
  bool? status;
  String? message;
  Details? details;

  FeedbackResponse({this.status, this.message, this.details});

  FeedbackResponse.fromJson(Map<String, dynamic> json) {
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
  int? userid;
  String? userName;
  String? message;
  String? updatedAt;
  String? createdAt;

  Details(
      {this.id,
      this.userid,
      this.userName,
      this.message,
      this.updatedAt,
      this.createdAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    userName = json['user_name'];
    message = json['message'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['user_name'] = this.userName;
    data['message'] = this.message;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
