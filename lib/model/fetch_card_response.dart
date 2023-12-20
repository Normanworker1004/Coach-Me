class FetchCardsResponse {
  bool? status;
  Message? message;

  FetchCardsResponse({this.status, this.message});

  FetchCardsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  List<Giftcard>? giftcard;
  List<Paymentcard>? paymentcard;

  Message({this.giftcard, this.paymentcard});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['Giftcard'] != null) {
      giftcard = <Giftcard>[];
      json['Giftcard'].forEach((v) {
        giftcard!.add(Giftcard.fromJson(v));
      });
    }
    // if (json['Paymentcard'] != null) {
    //   paymentcard = <Paymentcard>[];
    //   json['Paymentcard'].forEach((v) {
    //     paymentcard!.add(new Paymentcard.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.giftcard != null) {
      data['Giftcard'] = this.giftcard!.map((v) => v).toList();
    }
    // if (this.paymentcard != null) {
    //   data['Paymentcard'] = this.paymentcard!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Paymentcard {
  int? id;
  int? userid;
  String? nameOnCard;
  String? expiryDate;
  String? cardType;
  String? ccv;
  String? cardkey;
  String? createdAt;
  String? updatedAt;

  Paymentcard(
      {this.id,
      this.userid,
      this.nameOnCard,
      this.expiryDate,
      this.cardType,
      this.ccv,
      this.cardkey,
      this.createdAt,
      this.updatedAt});

  Paymentcard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    nameOnCard = json['nameOnCard'];
    expiryDate = json['expiryDate'];
    cardType = json['cardType'];
    ccv = json['ccv'];
    cardkey = json['cardkey'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['nameOnCard'] = this.nameOnCard;
    data['expiryDate'] = this.expiryDate;
    data['cardType'] = this.cardType;
    data['ccv'] = this.ccv;
    data['cardkey'] = this.cardkey;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Giftcard {
  int? id;
  String? cardnumber;
  int? buyerid;
  dynamic amount;
  int? giverid;
  dynamic balance;
  String? reason;
  String? createdAt;
  String? updatedAt;

  Giftcard(
      {this.id,
      this.cardnumber,
      this.buyerid,
      this.amount,
      this.giverid,
      this.balance,
      this.reason,
      this.createdAt,
      this.updatedAt});

  Giftcard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardnumber = json['cardnumber'];
    buyerid = json['buyerid'];
    amount = json['amount'];
    giverid = json['giverid'];
    balance = json['balance'];
    reason = json['reason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardnumber'] = this.cardnumber;
    data['buyerid'] = this.buyerid;
    data['amount'] = this.amount;
    data['giverid'] = this.giverid;
    data['balance'] = this.balance;
    data['reason'] = this.reason;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
