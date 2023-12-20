import 'package:cme/model/user_class/user_details.dart';

class PlayerLeaderBoardResponse {
  bool? status;
  String? message;
  PlayerPositionData? playerPositionData;
  List<LeagueChallengeSubDetails>? details;

  PlayerLeaderBoardResponse(
      {this.status, this.message, this.playerPositionData, this.details});

  PlayerLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    playerPositionData = json['response_data'] != null
        ? PlayerPositionData.fromJson(json['response_data'])
        : null;
    if (json['details'] != null) {
      details = <LeagueChallengeSubDetails>[];
      json['details'].forEach((v) {
        details!.add(LeagueChallengeSubDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.playerPositionData != null) {
      data['response_data'] = this.playerPositionData!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerPositionData {
  bool? isPlayerFound;
  String? message;
  int? myPosition;
  Userdata? userData;

  PlayerPositionData(
      {this.isPlayerFound, this.message, this.myPosition, this.userData});

  PlayerPositionData.fromJson(Map<String, dynamic> json) {
    isPlayerFound = json['status'];
    message = json['message'];
    myPosition = json['result'];
    userData =
        json['userdata'] != null ? Userdata.fromJson(json['userdata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.isPlayerFound;
    data['message'] = this.message;
    data['result'] = this.myPosition;
    if (this.userData != null) {
      data['userdata'] = this.userData!.toJson();
    }
    return data;
  }
}

class Userdata {
  int? userId;
  int? challengeDraw;
  int? challengeWin;
  int? challengeLoss;
  String? cnt;

  Userdata(
      {this.userId,
      this.challengeDraw,
      this.challengeWin,
      this.challengeLoss,
      this.cnt});

  Userdata.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    challengeDraw = json['challenge_draw'];
    challengeWin = json['challenge_win'];
    challengeLoss = json['challenge_loss'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['challenge_draw'] = this.challengeDraw;
    data['challenge_win'] = this.challengeWin;
    data['challenge_loss'] = this.challengeLoss;
    data['cnt'] = this.cnt;
    return data;
  }
}

class LeagueChallengeSubDetails {
  int? challengeDraw;
  int? challengeWin;
  int? challengeLoss;
  String? cnt;
  Userdetails? userdetails;

  LeagueChallengeSubDetails(
      {this.challengeDraw,
      this.challengeWin,
      this.challengeLoss,
      this.cnt,
      this.userdetails});

  LeagueChallengeSubDetails.fromJson(Map<String, dynamic> json) {
    challengeDraw = json['challenge_draw'];
    challengeWin = json['challenge_win'];
    challengeLoss = json['challenge_loss'];
    cnt = json['cnt'];
    userdetails = json['userdetails'] != null
        ? Userdetails.fromJson(json['userdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['challenge_draw'] = this.challengeDraw;
    data['challenge_win'] = this.challengeWin;
    data['challenge_loss'] = this.challengeLoss;
    data['cnt'] = this.cnt;
    if (this.userdetails != null) {
      data['userdetails'] = this.userdetails!.toJson();
    }
    return data;
  }
}
