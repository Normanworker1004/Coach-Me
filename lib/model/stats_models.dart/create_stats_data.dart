class CreateStatsDataResponse {
  bool? status;
  String? message;
  Details? details;

  CreateStatsDataResponse({this.status, this.message, this.details});

  CreateStatsDataResponse.fromJson(Map<String, dynamic> json) {
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
  String? statloc;
  String? mydata;
  String? updatedAt;
  String? createdAt;

  Details({this.id, this.statloc, this.mydata, this.updatedAt, this.createdAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statloc = json['statloc'];
    mydata = json['mydata'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statloc'] = this.statloc;
    data['mydata'] = this.mydata;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

