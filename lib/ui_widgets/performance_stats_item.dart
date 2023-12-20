import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/controllers/stats_controller.dart';
import 'package:cme/graph_import/graphs/charts_adapters/charts_index_sample.dart';
import 'package:cme/graph_import/stat_item.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/model/previous_home_stats.dart';
import 'package:cme/network/coach_stat/coach_stats_network_helper.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../app.dart';

class PerformanceStatItem extends StatefulWidget {
  final PlayerPerformanceStat? performanceStat;
  final bool showButton3;
  final bool hideAddRecord;
  final int ind;
  final Function? deleteItem;

  PerformanceStatItem(
      {this.performanceStat,
      this.showButton3 = false,
      this.hideAddRecord = false,
      this.ind = 0,
      this.deleteItem}) {
    // index = ind ?? 0;
  }

  @override
  _PerformanceStatItemState createState() => _PerformanceStatItemState();
}

class _PerformanceStatItemState extends State<PerformanceStatItem> {
  PlayerPerformanceStat? performanceStat;
  @override
  void initState() {
    super.initState();

    performanceStat = widget.performanceStat;
  }

  @override
  Widget build(BuildContext context) {
    TargetType targetType = TargetType.target_other;
    switch (performanceStat?.goal) {
      case "Hours of Training":
        targetType = TargetType.target_train_hr;
        break;
      case "Weight":
        targetType = TargetType.target_weight;
        break;
      case "Squats Completed":
        targetType = TargetType.target_squats;
        break;
      // case "Sprints Completed":
      //   targetType = TargetType.;
      //   break;
      default:
        targetType = TargetType.target_other;
    }

    return Obx(() {
      return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          // All actions are defined in the children parameter.
          children: [
            if (widget.deleteItem != null)
              SlidableAction(
                onPressed: (context) async {
                  widget.deleteItem!(performanceStat?.id, context);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Delete',
                icon: CupertinoIcons.bin_xmark_fill,
              ),
          ],
        ),
        child: StatItem(
          charts: [
            Container(
              height: 250,
              child: Charts(
                target: performanceStat?.target ?? 0,
                period: Period.WEEKLY,
                weeklyData: Get.find<StatsController>()
                        .currentUserModel
                        .value
                        .getPerformanceStats()
                        .elementAt(widget.ind)
                        .weekly ??
                    [],
              ),
            ),
            Container(
              height: 250,
              child: Charts(
                target: performanceStat?.target ?? 0,
                period: Period.MONTHLY,
                monthlyData: Get.find<StatsController>()
                        .currentUserModel
                        .value
                        .getPerformanceStats()
                        .elementAt(widget.ind)
                        .monthly ??
                    [],
              ),
            ),
            Container(
              height: 250,
              child: Charts(
                target: performanceStat?.target ?? 0,
                period: Period.YEARLY,
                yearlyData: Get.find<StatsController>()
                        .currentUserModel
                        .value
                        .getPerformanceStats()
                        .elementAt(widget.ind)
                        .yearly ??
                    [],
              ),
            ),
          ],
          targetType: targetType,
          title: "${performanceStat?.goal}",
          current: [
            performanceStat?.current / 52,
            performanceStat?.current / 12,
            performanceStat?.current
          ],
          target: [
            (performanceStat?.target ?? 1) / 52,
            (performanceStat?.target ?? 1) / 12,
            performanceStat?.target ?? 1
          ],
          img: "assets/stats15.png",
          onEditPerformanceStat: (targetValue) {
            saveTarget(targetValue);
          },
          onAddRecord: (recordValue) {
            saveRecord(recordValue);
          },
          onAddToHome: () {
            addToHome(userId: performanceStat?.userId, id: performanceStat?.id);
          },
          showButton3: widget.showButton3,
          hideAddRecord: widget.hideAddRecord,
        ),
      );
    });
  }

  saveTarget(double value) async {
    await updatePlayerPerformanceStats(
            token: Get.find<StatsController>()
                .currentUserModel
                .value
                .getAuthToken()!,
            target: value,
            goal: Get.find<StatsController>()
                .currentUserModel
                .value
                .getPerformanceStats()
                .elementAt(widget.ind)
                .goal,
            category: Get.find<StatsController>()
                .currentUserModel
                .value
                .getPerformanceStats()
                .elementAt(widget.ind)
                .category,
            statid: Get.find<StatsController>()
                .currentUserModel
                .value
                .getPerformanceStats()
                .elementAt(widget.ind)
                .id)
        .then((value) => (value) {
              toast("Stats Updated Successfully");
              print("Stats Updated Successfully");
            })
        .catchError((error) {
      toast("An Error occurred");
      print("Update Target Error");
      print(error);
    });

    Get.find<StatsController>()
        .currentUserModel
        .value
        .getPerformanceStats()
        .elementAt(widget.ind)
        .target = value;
    Get.find<StatsController>().currentUserModel.refresh();
    setState(() {});
    print("Done! Update Target");
    // response.whenComplete(() => {print(response)});
  }

  saveRecord(double value) async {
    print("Updating Stats");

    await addPlayerPerformanceStatsData(
            token: Get.find<StatsController>()
                .currentUserModel
                .value
                .getAuthToken()!,
            statid: Get.find<StatsController>()
                .currentUserModel
                .value
                .getPerformanceStats()
                .elementAt(widget.ind)
                .id,
            data: value)
        .then((value) => (value) {
              toast("Stats Updated Successfully");
              print("Stats Updated Successfully");
            })
        .catchError((error) {
      toast("An Error occurred");
      print("Update Target Error");
      print(error);
    });

    // Get.find<StatsController>().currentUserModel.value.getPerformanceStats().elementAt(widget.ind).data?[DateTime.now()] = value.toInt();

    Get.find<StatsController>().currentUserModel.refresh();

    setState(() {});
    // response.whenComplete(() => {print(response)});
  }

  void addToHome({int? userId, int? id}) async {
    print("userId: $userId, statsId: $id");
    PreviousHomeStats? homeStats = await getStatsHomeStateLocal();
    if (homeStats != null && userId == homeStats.userId) {
      homeStats.statsIds!.add(id);
    } else
      homeStats = PreviousHomeStats(userId: userId, statsIds: {id});

    var added = await saveStatsHomeStateLocal(homeStats);

    if (added) {
      toast("Added to Home");
      print("HomeStats updated");
      print(homeStats.toJson());
    }
  }
}
