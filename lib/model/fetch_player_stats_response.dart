import 'package:cme/model/player_performance_stats.dart';

class FetchPlayerStatsResponse {
  bool? status;
  String? message;
  List<StatDetails>? details;
  Map<String?, PlayerPerformanceStat>? performanceStats;

  FetchPlayerStatsResponse({this.status, this.message, this.details});

  FetchPlayerStatsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      details = <StatDetails>[];
      json['details'].forEach((v) {
        details!.add(StatDetails.fromJson(v));
      });
      if (details!.length >= 1) {
        performanceStats = {};
        details!.forEach((element) {
          collectPlayerPerformanceStats(element);
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  void collectPlayerPerformanceStats(StatDetails detail) {
    PlayerPerformanceStat performanceStat = PlayerPerformanceStat(
      goal: detail.goal,
      target: detail.target!.toDouble(),
      category: detail.category,
      id: detail.id,
      userId: detail.userid,
      data: {},
    );

    if (detail.playerstatistics != null &&
        detail.playerstatistics!.length != 0) {
      detail.playerstatistics!.forEach((element) {
        print("element....$element");
        performanceStat.data![element.getDate()] = element.amount;
        // addAll({element.getDate(): element.amount});
      });
    }
    performanceStats![performanceStat.goal] = performanceStat;
    //.addAll({performanceStat.goal: performanceStat});

    // if (performanceStat.goal != "Hours of Training" &&
    //     performanceStat.goal != "Sessions Completed") {
    //   UserStorage.performanceStatsList[performanceStat.id] = performanceStat;
    // }
  }
}

class StatDetails {
  int? id;
  int? userid;
  int? target;
  String? goal;
  String? category;
  String? createdAt;
  String? updatedAt;
  List<PlayerStatisticsData>? playerstatistics;

  StatDetails(
      {this.id,
      this.userid,
      this.target,
      this.goal,
      this.category,
      this.createdAt,
      this.updatedAt,
      this.playerstatistics});

  StatDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    target = json['target'];
    goal = json['goal'];
    category = json['category'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['playerstatistics'] != null) {
      playerstatistics = <PlayerStatisticsData>[];
      json['playerstatistics'].forEach((v) {
        playerstatistics!.add(PlayerStatisticsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['target'] = this.target;
    data['goal'] = this.goal;
    data['category'] = this.category;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.playerstatistics != null) {
      data['playerstatistics'] =
          this.playerstatistics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerStatisticsData {
  int? id;
  int? statloc;
  int? amount;
  String? createdAt;
  String? updatedAt;

  PlayerStatisticsData(
      {this.id, this.statloc, this.amount, this.createdAt, this.updatedAt});

  PlayerStatisticsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statloc = json['statloc'];
    amount = json['mydata'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['statloc'] = this.statloc;
    data['mydata'] = this.amount;
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
