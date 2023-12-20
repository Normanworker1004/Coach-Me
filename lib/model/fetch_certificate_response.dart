class FetchCertificateResponse {
  bool? status;
  String? message;
  List<CertificateDetails>? details;

  FetchCertificateResponse({this.status, this.message, this.details});

  FetchCertificateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details =  <CertificateDetails>[];
      json['details'].forEach((v) {
        details!.add( CertificateDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CertificateDetails {
  int? id;
  int? userid;
  String? name;
  String? createdAt;
  String? updatedAt;

  CertificateDetails({this.id, this.userid, this.name, this.createdAt, this.updatedAt});

  CertificateDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

