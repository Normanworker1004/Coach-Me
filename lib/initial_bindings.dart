import 'package:cme/controllers/video_call_controller.dart';
import 'package:get/get.dart';

import 'controllers/location_controller.dart';
import 'controllers/stats_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<StatsController>(StatsController(), permanent: true);
    Get.put<VideoCallController>(VideoCallController(), permanent: true);
    Get.put<LocationController>(LocationController(), permanent: true);
  }
}
