import 'package:cme/auth_scope_model/user_storage.dart';
import 'package:cme/model/bio_response.dart';
import 'package:cme/model/coach_booking_response.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/fetch_player_booking_resopnse.dart';
import 'package:cme/model/fetch_player_home_booking_response.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/model/user_class.dart';
import 'package:cme/model/user_class/profile_details.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  static final UserModel _userModel = UserModel._internal();
  factory UserModel() {
    return _userModel;
  }
  UserModel._internal();

  UserStorage storage = UserStorage();

  clearStorage() => storage = UserStorage();
  
  bool getShowChallengeResult() => storage.getShowChallengeResult();
  void setShowChallengeResult(bool u) {
    storage.setShowChallengeResult(u);
    notifyListeners();
  }

  List<TextEditingController?> getmatchUpP1Contoller() =>
      storage.getmatchUpP1Contoller();
  void setmatchUpP1Contoller(List<TextEditingController?> u) {
    storage.setmatchUpP1Contoller(u);
    notifyListeners();
  }

  List<TextEditingController?> getmatchUpP2Contoller() =>
      storage.getmatchUpP2Contoller();
  void setmatchUpP2Contoller(List<TextEditingController?> u) {
    storage.setmatchUpP2Contoller(u);
    notifyListeners();
  }

  ChallengeBookingDetails getCurrentchallenge() =>
      storage.getCurrentchallenge();
  void setCurrentChallenge(ChallengeBookingDetails u) {
    storage.setCurrentChallenge(u);
    notifyListeners();
  }

  UserClass getUser() => storage.getUser();
  int getCoachBookingCount() => storage.getCoachBookingCount();
  Userdetails? getUserDetails() => storage.getUserDetails();
  Profiledetails? getUserProfileDetails() => storage.getUserProfileDetails();

  FetchPlayerBookingResponse getPlayerBookings() => storage.playerBookings;
  void setPlayerBookings(FetchPlayerBookingResponse u) {
    storage.playerBookings = u;
    notifyListeners();
  }

  void setCoachBio(BioResponse u) {
    storage.coachBio = u;
    notifyListeners();
  }

  BioResponse getCoachBio() => storage.coachBio;

  FetchPlayerHomeBookingResponse? getPlayerHome() => storage.playerHome;
  void setPlayerHome(FetchPlayerHomeBookingResponse? u) {
    storage.playerHome = u;
   // notifyListeners(); // do not notify listener here //TODO : CHECK IF IT's OK to COMMENT THAT !!
  }

  void setUser(UserClass user) {
    storage.setUser(user);
    notifyListeners();
  }

  void setUserProfileDetails(Profiledetails? user) {
    storage.setUserProfileDetails(user);
    notifyListeners();
  }

  void setCoachBookingCount(int user) {
    storage.setCoachBookingCount(user);
    notifyListeners();
  }

  void updateCoachBookingCount(int user) {
    storage.setCoachBookingCount(user);
  //  notifyListeners();
  }

  void setUserDetails(Userdetails? user) {
    storage.setUserDetails(user);
    notifyListeners();
  }

  void setAuthToken(String? token) {
    storage.setAuthToken(token);
    notifyListeners();
  }

  String? getAuthToken() => storage.getAuthToken();

  void setCoachBookings(List<CoachBookingResponse> u) =>
      storage.coachBookings = u;
  List<CoachBookingResponse?> getCoachBookings() => storage.coachBookings;

  // Player Performance Stats
  void addPlayerPerformance({required PlayerPerformanceStat performanceStat}) {
    storage.addPlayerPerformanceStat(performanceStat: performanceStat);
    notifyListeners();
  }

  // Clear Player Performance Stats
  void clearPlayerPerformance() {
    storage.clearPlayerPerformanceStat();
    notifyListeners();
  }

  List<PlayerPerformanceStat> getPerformanceStats() =>
      storage.getPerformanceStatsList();
}
