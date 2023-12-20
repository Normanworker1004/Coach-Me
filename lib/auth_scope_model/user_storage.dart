import 'package:cme/model/bio_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/coach_earning_response.dart';
import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/fetch_player_booking_resopnse.dart';
import 'package:cme/model/fetch_player_home_booking_response.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/model/user_class.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:flutter/material.dart';

class UserStorage {
  static final UserStorage _userStorage = UserStorage._internal();
  factory UserStorage() {
    return _userStorage;
  }
  UserStorage._internal();


  FetchPlayerHomeBookingResponse? playerHome = FetchPlayerHomeBookingResponse();
  FetchPlayerBookingResponse playerBookings = FetchPlayerBookingResponse();
  UserClass currentUser = UserClass();
  Profiledetails? userProfileDetails = Profiledetails();
  Userdetails? userdetails = Userdetails(name: "");
  List<CoachBookingResponse?> coachBookings = List<CoachBookingResponse?>.filled(3, null, growable: false);
  FetchCardsResponse fetchCardsResponse = FetchCardsResponse(status: false);
  CoachEarningResponse coachEarningResponse = CoachEarningResponse();
  BioResponse coachBio = BioResponse(status: false);

  ChallengeBookingDetails playerCurrentChallenge = ChallengeBookingDetails();

  int coachBookingCount = 0;

  bool showChallengeResult = false;

  bool getShowChallengeResult() => showChallengeResult;
  void setShowChallengeResult(bool u) => showChallengeResult = u;

  List<TextEditingController?> matchUpP1Contoller =
      List<TextEditingController?>.filled(10, null, growable: false);
  List<TextEditingController?> matchUpP2Contoller =
      List<TextEditingController?>.filled(10, null, growable: false);

  List<TextEditingController?> getmatchUpP1Contoller() => matchUpP1Contoller;
  void setmatchUpP1Contoller(List<TextEditingController?> u) =>
      matchUpP1Contoller = u;

  List<TextEditingController?> getmatchUpP2Contoller() => matchUpP2Contoller;
  void setmatchUpP2Contoller(List<TextEditingController?> u) =>
      matchUpP2Contoller = u;

  ChallengeBookingDetails getCurrentchallenge() => playerCurrentChallenge;
  void setCurrentChallenge(ChallengeBookingDetails u) =>
      playerCurrentChallenge = u;

  void setCoachBookingCount(int u) => coachBookingCount = u;

  int getCoachBookingCount() => coachBookingCount;
  void setCoachBio(BioResponse u) => coachBio = u;

  FetchPlayerHomeBookingResponse? getPlayerHome() => playerHome;
  void setPlayerHome(FetchPlayerHomeBookingResponse u) => playerHome = u;

  FetchPlayerBookingResponse getPlayerBookings() => playerBookings;
  void setPlayerBookings(FetchPlayerBookingResponse u) => playerBookings = u;

  BioResponse getCoachBio() => coachBio;
  void setCoachBookings(List<CoachBookingResponse> u) => coachBookings = u;

  List<CoachBookingResponse?> getCoachBookings() => coachBookings;
  void setUserDetails(Userdetails? u) => userdetails = u;

  Userdetails? getUserDetails() => userdetails;
  void setUserProfileDetails(Profiledetails? u) => userProfileDetails = u;

  Profiledetails? getUserProfileDetails() => userProfileDetails;
  UserClass getUser() => currentUser;

  void setUser(UserClass user) {
    currentUser = user;
    userdetails = user.details;
  }

  String? getAuthToken() => currentUser.token;

  void setAuthToken(String? token) => currentUser.token = token;

  // For Player Stats... This is going to be here for the mean time until there's
  // proper connection with the server
  static Map<int?, PlayerPerformanceStat> performanceStatsList = {};

  void addPlayerPerformanceStat({required PlayerPerformanceStat performanceStat}) =>
      performanceStatsList[performanceStat.id] = performanceStat;

  void clearPlayerPerformanceStat() =>
      performanceStatsList.clear();

  List<PlayerPerformanceStat> getPerformanceStatsList() =>
      performanceStatsList.values.toList();
}

// String localToken =
//     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNjAwNDIyNjk3LCJleHAiOjE2MDA1MDkwOTd9.p_xvMkyRaesch_4KrkQ-XWBzz2bFqUnxRT53sTi-jv0";
