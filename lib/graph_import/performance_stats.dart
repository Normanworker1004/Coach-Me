import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/graph_import/add_performance_stats_widget.dart';
import 'package:cme/model/fetch_player_stats_response.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/ui_widgets/performance_stats_item.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/stats_controller.dart';

class PerformancePage extends StatefulWidget {
  final UserModel? userModel;

  PerformancePage(this.userModel);

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
    final StatsController statsController = Get.find<StatsController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Obx(() {
                  return AddPerformanceStats(
                    statsController.currentUserModel.value,
                    stateParser: (addStat) {
                        statsController.addStats.value = addStat;
                    },
                  );
                }
              ),
              height: 287,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(3, 12, 30, 1),
              ),
            ),
          ),
          verticalSpace(height: 4),
          FutureBuilder<FetchPlayerStatsResponse>(
              future: fetchPlayerStatsData(
                token: statsController.currentUserModel.value.getAuthToken()!,
              ),
              builder: (context, snapshot) {
                if (snapshot == null) {
                  return Container(
                    child: Center(
                      child: mediumText("Unable to fetch your stats data"),
                    ),
                  );
                }

                //details
                if (snapshot.data == null) {
                  return Container(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }
                var r = snapshot.data!;

                statsController.currentUserModel.value.clearPlayerPerformance();

                List<PlayerPerformanceStat> statsList = [];
                r.performanceStats?.forEach((key, value) {
                  if ("$key" != "Hours of Training" ||
                      "$key" != "Sessions Completed") {
                    print("add....");
                    statsList.add(value);
                    print("target....${value.target}");
                    statsController.currentUserModel.value.addPlayerPerformance(performanceStat: value);
                  }
                });
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                  ),
                  child: Column(
                        children: statsList != 0
                            ? List.generate(statsList.length, (index) {
                                return /* addStats
                                    ? PerformanceStatItem(
                                        performanceStat: statsList[index],
                                        showButton3: true,
                                        userModel: widget.userModel,
                                      )
                                    : */
                                  PerformanceStatItem(
                                  performanceStat: statsList[index],
                                  showButton3: true,
                                    ind: index,
                                );
                              })
                            : [],
                      )

                );

                /*
                return ScopedModel<UserModel>(
                  model: widget.userModel,
                  child: ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                      UserModel player = model;
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                        ),
                        child: Column(
                          children: player.getPerformanceStats().length != 0
                              ? List.generate(
                                  player.getPerformanceStats().length, (index) {
                                  return addStats
                                      ? PerformanceStatItem(
                                          performanceStat: player
                                              .getPerformanceStats()[index],
                                          showButton3: true,
                                          userModel: widget.userModel,
                                        )
                                      : PerformanceStatItem(
                                          performanceStat: player
                                              .getPerformanceStats()[index],
                                          showButton3: false,
                                          userModel: widget.userModel,
                                        );
                                })
                              : [],
                        ),
                      );
                    },
                  ),
                );
                */
              })
        ],
      ),
    );
  }
}
