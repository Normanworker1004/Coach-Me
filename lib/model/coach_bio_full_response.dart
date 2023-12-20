import 'package:cme/model/user_class/user_details.dart';

class CoachBioFullInfoResponse {
  bool? status;
  String? description;
  List<BioSubDetail>? bioSubDetaiList;

  CoachBioFullInfoResponse(
      {this.status, this.description, this.bioSubDetaiList});

  CoachBioFullInfoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    description = json['description'];
    if (json['Profile'] != null) {
      bioSubDetaiList = <BioSubDetail>[];
      json['Profile'].forEach((v) {
        bioSubDetaiList!.add(BioSubDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.bioSubDetaiList != null) {
      data['Profile'] = this.bioSubDetaiList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BioSubDetail {
  int? id;
  int? userid;
  String? sport;
  int? bioLevel;
  String? bioLocation;
  dynamic bioLat;
  dynamic bioLon;
  dynamic bioRadius;
  dynamic bioPrice;
  String? bioAbout;
  String? bioExpertise;
  String? bioGameplay;
  String? bioAge;
  String? createdAt;
  String? updatedAt;
  Userdetails? coachDetails;

  BioSubDetail(
      {this.id,
      this.userid,
      this.sport,
      this.bioLevel,
      this.bioLocation,
      this.bioLat,
      this.bioLon,
      this.bioRadius,
      this.bioPrice,
      this.bioAbout,
      this.bioExpertise,
      this.bioGameplay,
      this.bioAge,
      this.createdAt,
      this.updatedAt,
      this.coachDetails});

  BioSubDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    sport = json['sport'];
    bioLevel = json['bio_level'];
    bioLocation = json['bio_location'];
    bioLat = json['bio_lat'];
    bioLon = json['bio_lon'];
    bioRadius = json['bio_radius'];
    bioPrice = json['bio_price'];
    bioAbout = json['bio_about'];
    bioExpertise = json['bio_expertise'];
    bioGameplay = json['bio_gameplay'];
    bioAge = json['bio_age'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    coachDetails =
        json['bioinfo'] != null ? Userdetails.fromJson(json['bioinfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['sport'] = this.sport;
    data['bio_level'] = this.bioLevel;
    data['bio_location'] = this.bioLocation;
    data['bio_lat'] = this.bioLat;
    data['bio_lon'] = this.bioLon;
    data['bio_radius'] = this.bioRadius;
    data['bio_price'] = this.bioPrice;
    data['bio_about'] = this.bioAbout;
    data['bio_expertise'] = this.bioExpertise;
    data['bio_gameplay'] = this.bioGameplay;
    data['bio_age'] = this.bioAge;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.coachDetails != null) {
      data['bioinfo'] = this.coachDetails!.toJson();
    }
    return data;
  }
}
