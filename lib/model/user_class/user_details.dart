import 'package:cme/model/coach_bio_full_response.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/sport.dart';
import 'package:cme/utils/convert_useraname.dart';

class Userdetails {
  Sport? sport;
  int? id;
  String? name;
  String? username;
  String? email;
  String? password;
  String? ageGroup;
  String? usertype;
  String? countryId;
  String? dob;
  String? guardianName;
  String? guardianDob;
  String? guardianPhone;
  String? guardianEmail;
  String? guardCountryId;
  String? affiliateCode;
  String? referedBy;
  dynamic phoneVerify;
  String? gender;
  String? profilePic;
  String? mapPic;
  dynamic subscriptionId;
  String? phone;
  String? markerting;
  dynamic lon;
  dynamic lat;
  String? createdAt;
  String? updatedAt;

  Profiledetails? profile;
  List<BioSubDetail>? bioSubDetaiList;

  Userdetails(
      {this.sport,
      this.id,
      this.name,
      this.username,
      this.email,
      this.password,
      this.ageGroup,
      this.usertype,
      this.countryId,
      this.dob,
      this.guardianName,
      this.guardianDob,
      this.guardianPhone,
      this.guardianEmail,
      this.guardCountryId,
      this.affiliateCode,
      this.referedBy,
      this.phoneVerify,
      this.gender,
      this.profilePic,
      this.mapPic,
      this.subscriptionId,
      this.phone,
      this.markerting,
      this.lon,
      this.lat,
      this.createdAt,
      this.profile,
      this.bioSubDetaiList,
      this.updatedAt});

  Userdetails.fromJson(Map<String, dynamic> json) {
    try {
      sport = json['sport'] != null ? new Sport.fromJson(json['sport']) : null;
    } catch (e) {
      sport = Sport(
        level: [1, 2],
        sport: ["football", "tennis"],
      );
    }

    id = json['id'];
    name = convertUserName(json['name']);
    username = json['username'];
    email = json['email'];
    password = json['password'];
    ageGroup = json['age_group'];
    usertype = json['usertype'];
    countryId = json['country_id'];
    dob = json['dob'];
    guardianName = json['guardian_name'];
    guardianDob = json['guardian_dob'];
    guardianPhone = json['guardian_phone'];
    guardianEmail = json['guardian_email'];
    guardCountryId = json['guard_country_id'];
    affiliateCode = json['affiliate_code'];
    referedBy = json['refered_by'];
    phoneVerify = json['phone_verify'];
    gender = json['gender'];
    profilePic = json['profile_pic'] ?? "avatar.png";
    mapPic = json['map_pic'] ?? "avatar.png";
    subscriptionId = json['subscription_id'] ?? 0;
    phone = json['phone'];
    markerting = json['markerting'];
    lon = json['lon'];
    lat = json['lat'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['coachprofile'] != null) {
      profile = new Profiledetails.fromJson(json['coachprofile']);
    }
    if (json['playerprofile'] != null) {
      profile = new Profiledetails.fromJson(json['playerprofile']);
    }
    if (json['bioinfoforuser'] != null) {
      bioSubDetaiList = <BioSubDetail>[];
      json['bioinfoforuser'].forEach((v) {
        bioSubDetaiList!.add(BioSubDetail.fromJson(v));
      });
      print("bio sub completed......");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sport != null) {
      data['sport'] = this.sport!.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['age_group'] = this.ageGroup;
    data['usertype'] = this.usertype;
    data['country_id'] = this.countryId;
    data['dob'] = this.dob;
    data['guardian_name'] = this.guardianName;
    data['guardian_dob'] = this.guardianDob;
    data['guardian_phone'] = this.guardianPhone;
    data['guardian_email'] = this.guardianEmail;
    data['guard_country_id'] = this.guardCountryId;
    data['affiliate_code'] = this.affiliateCode;
    data['refered_by'] = this.referedBy;
    data['phone_verify'] = this.phoneVerify;
    data['gender'] = this.gender;
    data['profile_pic'] = this.profilePic;
    data['map_pic'] = this.mapPic;
    data['subscription_id'] = this.subscriptionId;
    data['phone'] = this.phone;
    data['markerting'] = this.markerting;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.profile != null) {
      data['coachprofile'] = this.profile!.toJson();
      data['playerprofile'] = this.profile!.toJson();
    }
    return data;
  }
}
