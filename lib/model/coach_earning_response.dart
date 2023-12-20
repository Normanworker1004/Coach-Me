class CoachEarningResponse {
  bool? status;
  String? message;
  List<Details>? details;

  CoachEarningResponse({this.status, this.message, this.details});

  CoachEarningResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
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

class Details {
  int? id;
  int? coachID;
  int? playerID;
  String? details;
  dynamic amount;
  String? type;
  String? createdAt;
  String? updatedAt;

  Details(
      {this.id,
      this.coachID,
      this.playerID,
      this.details,
      this.amount,
      this.type,
      this.createdAt,
      this.updatedAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coachID = json['coachID'];
    playerID = json['playerID'];
    details = json['details'];
    amount = json['amount'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coachID'] = this.coachID;
    data['playerID'] = this.playerID;
    data['details'] = this.details;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
