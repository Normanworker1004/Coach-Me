class FetchPaymentHistoryResponse {
  bool? status;
  String? message;
  List<PaymentDetails>? details;

  FetchPaymentHistoryResponse({this.status, this.message, this.details});

  FetchPaymentHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <PaymentDetails>[];
      json['details'].forEach((v) {
        details!.add(new PaymentDetails.fromJson(v));
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

class PaymentDetails {
  int? id;
  int? userid;
  String? ref;
  String? paymentTitle;
  String? paymentType;
  int? amount;
  int? bookingID;
  String? bookingType;
  String? paymentOption;
  String? paymentOptionID;
  String? createdAt;
  String? updatedAt;

  PaymentDetails(
      {this.id,
      this.userid,
      this.ref,
      this.paymentTitle,
      this.paymentType,
      this.amount,
      this.bookingID,
      this.bookingType,
      this.paymentOption,
      this.paymentOptionID,
      this.createdAt,
      this.updatedAt});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    ref = json['ref'];
    paymentTitle = json['paymentTitle'];
    paymentType = json['paymentType'];
    amount = json['amount'];
    bookingID = json['bookingID'];
    bookingType = json['bookingType'];
    paymentOption = json['paymentOption'];
    paymentOptionID = json['paymentOptionID'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['ref'] = this.ref;
    data['paymentTitle'] = this.paymentTitle;
    data['paymentType'] = this.paymentType;
    data['amount'] = this.amount;
    data['bookingID'] = this.bookingID;
    data['bookingType'] = this.bookingType;
    data['paymentOption'] = this.paymentOption;
    data['paymentOptionID'] = this.paymentOptionID;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
