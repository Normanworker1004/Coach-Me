class AddCardResponse {
  bool? status;
  String? message;
  Details? details;

  AddCardResponse({this.status, this.message, this.details});

  AddCardResponse.fromJson(Map<String, dynamic> json) {
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
  String? nameOnCard;
  String? expiryDate;
  String? cardType;
  String? ccv;
  String? updatedAt;
  String? createdAt;

  Details(
      {this.id,
      this.userid,
      this.nameOnCard,
      this.expiryDate,
      this.cardType,
      this.ccv,
      this.updatedAt,
      this.createdAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    nameOnCard = json['nameOnCard'];
    expiryDate = json['expiryDate'];
    cardType = json['cardType'];
    ccv = json['ccv'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['nameOnCard'] = this.nameOnCard;
    data['expiryDate'] = this.expiryDate;
    data['cardType'] = this.cardType;
    data['ccv'] = this.ccv;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
