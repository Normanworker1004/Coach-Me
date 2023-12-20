import 'package:cme/model/user_class/sport.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/utils/convert_useraname.dart';

class Profiledetails {
  Sport? sport;
  int? id;
  int? userId;
  List<int>? levelBlocker;
  dynamic rating;
  dynamic session;
  String? aboutme;
  dynamic lat;
  dynamic lon;
  String? location;
  dynamic radius;
  dynamic sessionPrice;
  String? ageGroup;
  String? expertise;
  String? gamePlay;
  String? certificate;
  dynamic points;
  String? alias;
  String? bankAccountName;
  String? bankAccountNumber;
  String? bankName;
  String? bankSortCode;
  String? createdAt;
  String? updatedAt;

  dynamic bookingPt;
  dynamic socialsharePt;
  dynamic appusagePt;

  dynamic totalPoints = 0;
  Userdetails? user;

  Profiledetails(
      {this.sport,
      this.id,
      this.userId,
      this.rating,
      this.session,
      this.aboutme,
      this.lat,
      this.lon,
      this.location,
      this.radius,
      this.sessionPrice,
      this.ageGroup,
      this.expertise,
      this.gamePlay,
      this.certificate,
      this.points,
      this.alias,
      this.bankAccountName,
      this.bankAccountNumber,
      this.bankName,
      this.bankSortCode,
      this.createdAt,
      this.bookingPt,
      this.socialsharePt,
      this.appusagePt,
      this.updatedAt});

  Profiledetails.fromJson(Map<String, dynamic> json) {
    try {
      sport = json['sport'] != null ? new Sport.fromJson(json['sport']) : null;
      levelBlocker = json['level_blocker'].cast<int>() ?? [];
    } catch (e) {
      print("Error converting to sport..profile. $e");


      sport = Sport(
        level: [],
        sport: [],
      );
      // print("Error converting to sport..profile.");
    }
    id = json['id'];
    userId = json['user_id'];
    rating = json['rating'];
    session = json['session'];
    aboutme = json['aboutme'];
    lat = json['lat'];
    lon = json['lon'];
    location = json['location'];
    radius = json['radius'];
    sessionPrice = json['sessio6nPrice'];
    ageGroup = json['ageGroup'];
    expertise = json['expertise'];
    gamePlay = json['gamePlay'];
    certificate = json['certificate'];
    points = json['points'];
    alias = json['Alias'];
    bankAccountName = convertUserName(json['bankAccountName']);
    bankAccountNumber = json['bankAccountNumber'];
    bankName = json['bankName'];
    bankSortCode = json['bankSortCode'];
    bookingPt = json['booking_pt'] ?? 0;
    socialsharePt = json['socialshare_pt'] ?? 0;
    appusagePt = json['appusage_pt'] ?? 0;

    // // totalPoints = appusagePt + socialsharePt + bookingPt;
    // print(
    //     "add up total....$appusagePt..$socialsharePt.$bookingPt.....$totalPoints");
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new Userdetails.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sport != null) {
      data['sport'] = this.sport!.toJson();
    }
    data['level_blocker'] = this.levelBlocker;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['session'] = this.session;
    data['aboutme'] = this.aboutme;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['location'] = this.location;
    data['radius'] = this.radius;
    data['sessionPrice'] = this.sessionPrice;
    data['ageGroup'] = this.ageGroup;
    data['expertise'] = this.expertise;
    data['gamePlay'] = this.gamePlay;
    data['certificate'] = this.certificate;
    data['points'] = this.points;
    data['Alias'] = this.alias;
    data['bankAccountName'] = this.bankAccountName;
    data['bankAccountNumber'] = this.bankAccountNumber;
    data['bankName'] = this.bankName;
    data['bankSortCode'] = this.bankSortCode;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    data['booking_pt'] = this.bookingPt;
    data['socialshare_pt'] = this.socialsharePt;
    data['appusage_pt'] = this.appusagePt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
