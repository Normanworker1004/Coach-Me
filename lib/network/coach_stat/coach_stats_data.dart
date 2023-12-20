import 'package:cme/graph_import/graphs/charts_adapters/chart_data_model.dart';
import 'package:cme/graph_import/graphs/earnings/earnings.dart';

class CoachStatisticsData {
  bool? status;
  String? description;
  CoachStatsDetails? details;

  List<WeeklyEarningsModel> weeklyEarning = [];
  List<EarningsModel> monthlyEarning = [];
  List<EarningsModel> yearlyEarning = [];
  List<WeeklyStatsDataModel> weeklySessionsCompleted = [];
  List<StatsDataModel> monthlySessionsCompleted = [];
  List<StatsDataModel> yearlySessionsCompleted = [];
  double? earningsTarget;
  double earningsCurrent = 0;
  double? sessionCompletedTarget;
  double sessionsCompletedCurrent = 0;
  double? hoursCompletedTarget;
  double hoursCompletedCurrent = 0;
  double? sessionPrice;
  double rating = 0;

  CoachStatisticsData({this.details, this.status});

  CoachStatisticsData.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? new CoachStatsDetails.fromJson(json['details'])
        : null;
    collectEarningsData(details!);
    collectTargets(details!);
    collectSessionsData(details!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }

  // TODO: I stopped at creating the data in the weeklyEarning, monthlyEarning, yearlyEarning.
  // I am supposed to continue on to collecting the data for sessions and rating separately

  collectEarningsData(CoachStatsDetails details) {
    // Weekly
    List<EarningData> weekly = details.weekearning!;
    for (int i = 0; i < weekly.length; i++) {
      WeeklyEarningsModel wEarning = WeeklyEarningsModel(
          weekly[i].amount!.toDouble(),
          day: (weekly[i].getDate().weekday - 1));
      weeklyEarning.add(wEarning);
    }
    // monthly
    List<EarningData> monthly = details.monthearning!;
    for (int i = 0; i < monthly.length; i++) {
      EarningsModel mEarning =
          EarningsModel(monthly[i].getDate(), monthly[i].amount!.toDouble());
      monthlyEarning.add(mEarning);
    }
    // yearly
    List<EarningData> yearly = details.yearearning!;
    for (int i = 0; i < yearly.length; i++) {
      EarningsModel yEarning =
          EarningsModel(yearly[i].getDate(), yearly[i].amount!.toDouble());
      yearlyEarning.add(yEarning);
      earningsCurrent += yEarning.amount ;
    }
  }

  collectSessionsData(CoachStatsDetails details) {
    sessionPrice = details.statProfile!.sessionPrice!.toDouble();
    // weekly
    List<RatingAndSessionData> weekly = details.weekRatingAndSession!;
    for (int i = 0; i < weekly.length; i++) {
      WeeklyStatsDataModel wSession = WeeklyStatsDataModel(
          weekly[i].exSession!.toDouble(),
          day: weekly[i].getDate().weekday - 2);
      weeklySessionsCompleted.add(wSession);
    }
    // monthly
    List<RatingAndSessionData> monthly = details.monthRatingAndSession!;
    for (int i = 0; i < monthly.length; i++) {
      StatsDataModel mSession =
          StatsDataModel(monthly[i].getDate(), monthly[i].exSession!.toDouble());
      monthlySessionsCompleted.add(mSession);
    }
    // monthly
    List<RatingAndSessionData> yearly = details.yearRatingAndSession!;
    for (int i = 0; i < yearly.length; i++) {
      StatsDataModel ySession =
          StatsDataModel(yearly[i].getDate(), yearly[i].exSession!.toDouble());
      yearlySessionsCompleted.add(ySession);
      sessionsCompletedCurrent += ySession.amount ;
      hoursCompletedCurrent += ySession.amount ;

      rating += yearly[i].exRating ?? 0;
    }
  }

  void collectTargets(CoachStatsDetails details) {
    earningsTarget = details.statProfile!.targetEarning.toDouble();
    sessionCompletedTarget = details.statProfile!.targetSession.toDouble();
    hoursCompletedTarget = details.statProfile!.targetHour.toDouble();
  }
}

class CoachStatsDetails {
  List<EarningData>? monthearning;
  List<EarningData>? weekearning;
  List<EarningData>? yearearning;
  List<RatingAndSessionData>? weekRatingAndSession;
  List<RatingAndSessionData>? monthRatingAndSession;
  List<RatingAndSessionData>? yearRatingAndSession;
  StatProfile? statProfile;
  double? exRating;

  CoachStatsDetails(
      {this.monthearning,
      this.weekearning,
      this.yearearning,
      this.weekRatingAndSession,
      this.monthRatingAndSession,
      this.yearRatingAndSession,
      this.statProfile});

  CoachStatsDetails.fromJson(Map<String, dynamic> json) {
    if (json['monthearning'] != null) {
      monthearning = <EarningData>[];
      json['monthearning'].forEach((v) {
        monthearning!.add(new EarningData.fromJson(v));
      });
    }
    if (json['weekearning'] != null) {
      weekearning = <EarningData>[];
      json['weekearning'].forEach((v) {
        weekearning!.add(new EarningData.fromJson(v));
      });
    }
    if (json['yearearning'] != null) {
      yearearning = <EarningData>[];
      json['yearearning'].forEach((v) {
        yearearning!.add(new EarningData.fromJson(v));
      });
    }
    if (json['weekrating_and_session'] != null) {
      weekRatingAndSession = <RatingAndSessionData>[];
      json['weekrating_and_session'].forEach((v) {
        weekRatingAndSession!.add(new RatingAndSessionData.fromJson(v));
      });
    }
    if (json['monthrating_and_session'] != null) {
      monthRatingAndSession = <RatingAndSessionData>[];
      json['monthrating_and_session'].forEach((v) {
        monthRatingAndSession!.add(new RatingAndSessionData.fromJson(v));
      });
    }
    if (json['yearrating_and_session'] != null) {
      yearRatingAndSession = <RatingAndSessionData>[];
      json['yearrating_and_session'].forEach((v) {
        yearRatingAndSession!.add(new RatingAndSessionData.fromJson(v));
      });
    }
    statProfile = json['stat_profile'] != null
        ? new StatProfile.fromJson(json['stat_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.monthearning != null) {
      data['monthearning'] = this.monthearning!.map((v) => v.toJson()).toList();
    }
    if (this.weekearning != null) {
      data['weekearning'] = this.weekearning!.map((v) => v.toJson()).toList();
    }
    if (this.yearearning != null) {
      data['yearearning'] = this.yearearning!.map((v) => v.toJson()).toList();
    }
    if (this.weekRatingAndSession != null) {
      data['weekrating_and_session'] =
          this.weekRatingAndSession!.map((v) => v.toJson()).toList();
    }
    if (this.monthRatingAndSession != null) {
      data['monthrating_and_session'] =
          this.monthRatingAndSession!.map((v) => v.toJson()).toList();
    }
    if (this.yearRatingAndSession != null) {
      data['yearrating_and_session'] =
          this.yearRatingAndSession!.map((v) => v.toJson()).toList();
    }
    if (this.statProfile != null) {
      data['stat_profile'] = this.statProfile!.toJson();
    }
    return data;
  }
}

class EarningData {
  int? id;
  int? coachID;
  int? playerID;
  String? details;
  int? amount;
  String? type;
  String? createdAt;
  String? updatedAt;

  EarningData(
      {this.id,
      this.coachID,
      this.playerID,
      this.details,
      this.amount,
      this.type,
      this.createdAt,
      this.updatedAt});

  EarningData.fromJson(Map<String, dynamic> json) {
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

  DateTime getDate() {
    List<String> dateString = createdAt!.split('T')[0].split('-');
    return DateTime(int.parse(dateString[0]), int.parse(dateString[1]),
        int.parse(dateString[2]));
  }
}

class RatingAndSessionData {
  double? exRating;
  int? exSession;
  String? createdAt;

  RatingAndSessionData({this.exRating, this.exSession, this.createdAt});

  RatingAndSessionData.fromJson(Map<String, dynamic> json) {
    exRating = double.parse("${json['ex_rating']}");
    exSession = json['ex_session'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ex_rating'] = this.exRating;
    data['ex_session'] = this.exSession;
    data['createdAt'] = this.createdAt;
    return data;
  }

  DateTime getDate() {
    List<String> dateString = createdAt!.split('T')[0].split('-');
    return DateTime(int.parse(dateString[0]), int.parse(dateString[1]),
        int.parse(dateString[2]));
  }
}

class StatProfile {
  Map<String, dynamic>? sport;
  int? id;
  int? userId;
  int? rating;
  int? session;
  String? aboutme;
  double? lat;
  double? lon;
  String? usertype;
  String? location;
  int? radius;
  double? sessionPrice;
  String? ageGroup;
  String? expertise;
  String? gamePlay;
  String? certificate;
  int? points;
  String? alias;
  String? bankAccountName;
  String? bankAccountNumber;
  String? bankName;
  String? bankSortCode;
  int? bookingPt;
  int? socialsharePt;
  int? appusagePt;
  dynamic targetSession;
  dynamic targetHour;
  dynamic targetEarning;
  int? targetTrainHr;
  int? targetWeight;
  int? targetGoalScored;
  int? targetSquats;
  String? createdAt;
  String? updatedAt;

  StatProfile(
      {this.sport,
      this.id,
      this.userId,
      this.rating,
      this.session,
      this.aboutme,
      this.lat,
      this.lon,
      this.usertype,
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
      this.bookingPt,
      this.socialsharePt,
      this.appusagePt,
      this.targetSession,
      this.targetHour,
      this.targetEarning,
      this.targetTrainHr,
      this.targetWeight,
      this.targetGoalScored,
      this.targetSquats,
      this.createdAt,
      this.updatedAt});

  StatProfile.fromJson(Map<String, dynamic> json) {
    sport = json['sport'];
    id = json['id'];
    userId = json['user_id'];
    rating = json['rating'];
    session = json['session'];
    aboutme = json['aboutme'];
    lat = json['lat'];
    lon = json['lon'];
    usertype = json['usertype'];
    location = json['location'];
    radius = json['radius'];
    sessionPrice = double.parse("${json['sessionPrice']}");
    ageGroup = json['ageGroup'];
    expertise = json['expertise'];
    gamePlay = json['gamePlay'];
    certificate = json['certificate'];
    points = json['points'];
    alias = json['Alias'];
    bankAccountName = json['bankAccountName'];
    bankAccountNumber = json['bankAccountNumber'];
    bankName = json['bankName'];
    bankSortCode = json['bankSortCode'];
    bookingPt = json['booking_pt'];
    socialsharePt = json['socialshare_pt'];
    appusagePt = json['appusage_pt'];
    targetSession = json['target_session'];
    targetHour = json['target_hour'];
    targetEarning = json['target_earning'];
    targetTrainHr = json['target_train_hr'];
    targetWeight = json['target_weight'];
    targetGoalScored = json['target_goal_scored'];
    targetSquats = json['target_squats'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sport'] = this.sport;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['session'] = this.session;
    data['aboutme'] = this.aboutme;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['usertype'] = this.usertype;
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
    data['booking_pt'] = this.bookingPt;
    data['socialshare_pt'] = this.socialsharePt;
    data['appusage_pt'] = this.appusagePt;
    data['target_session'] = this.targetSession;
    data['target_hour'] = this.targetHour;
    data['target_earning'] = this.targetEarning;
    data['target_train_hr'] = this.targetTrainHr;
    data['target_weight'] = this.targetWeight;
    data['target_goal_scored'] = this.targetGoalScored;
    data['target_squats'] = this.targetSquats;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
