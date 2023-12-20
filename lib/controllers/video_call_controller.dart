import 'package:cme/auth_scope_model/user_model.dart';
import 'package:get/get.dart';

import '../model/player_performance_stats.dart';

class VideoCallController extends GetxController{

   var callInProgress = false.obs;
   var timerText = "".obs;
   var isJoined = false.obs;

   void reinit() {
      callInProgress.value = false;
      timerText.value = "";
      isJoined.value = false;
   }
}