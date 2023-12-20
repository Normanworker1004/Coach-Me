import 'package:cme/auth_scope_model/user_model.dart';
import 'package:get/get.dart';

import '../model/player_performance_stats.dart';

class StatsController extends GetxController{

  var currentUserModel = UserModel().obs;
  var currentTabIndex = 0.obs;
  var addStats = false.obs;

}