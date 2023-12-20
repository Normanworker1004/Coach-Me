class PaymentCardUpdateResponse {
  bool? status;
  String? message;
  dynamic details;

  PaymentCardUpdateResponse({this.status, this.message, this.details});

  PaymentCardUpdateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['details'] = this.details;
    return data;
  }
}
