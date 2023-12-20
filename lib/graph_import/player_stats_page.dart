import 'dart:async';

import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/graph_import/performance_stats.dart';
import 'package:cme/graph_import/season_complete_meter.dart';
import 'package:cme/model/fetch_player_stats_response.dart';
import 'package:cme/model/player_performance_stats.dart';
import 'package:cme/model/previous_home_stats.dart';
import 'package:cme/network/coach_stat/coach_stats_network_helper.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/ui_widgets/performance_stats_item.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:cme/graph_import/stat_item.dart';
import 'package:cme/graph_import/stats/graph_widgets/goals_scored_graph.dart';
import 'package:cme/graph_import/stats/graph_widgets/hours_graph.dart';
import 'package:get/get.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:provider/provider.dart';

import '../auth_scope_model/ui_provider.dart';
import '../controllers/stats_controller.dart';
import '../model/fetch_player_home_booking_response.dart';
import '../network/player/fetch_home.dart';
import 'fixtures_section.dart';
import 'graphs/charts_adapters/charts_index_sample.dart';

class PlayerStatsPage extends StatelessWidget {
  final UserModel? userModel;
  final TooltipController tooltipController;

  List<String> l = ["Dashboard", "Set Goals", "My fixtures"];
  int index = 0;

  List<PlayerPerformanceStat> performanceStats = [];
  final StatsController statsController = Get.find<StatsController>();

  PlayerStatsPage(
      {Key? key, required this.userModel, required this.tooltipController}) {
    var u = Get.context?.read<UIProvider>();
    var glbIndex = u?.getCurrentScreenSubIndex() ?? 0;
    index = glbIndex == 0 ? index : glbIndex;
    statsController.currentUserModel.value = userModel!;
  }

  @override
  Widget build(BuildContext context) {
    return /*buildBaseScaffold(
      lrPadding: 0,
      bottomPadding: 0,
      context: context,
      hideBack: true,
      title: "Stats",
      body:*/

        Column(
      children: [
        buildTab(),
        verticalSpace(height: 15),
        Expanded(
          child: Obx(() {
            return IndexedStack(
              index: statsController.currentTabIndex.value,
              children: [
                // Home
                RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 2));
                  },
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      buildSessionCompletedMeter(),
                      verticalSpace(height: 16),
                      buildHome(),
                    ],
                  )),
                ),
                // Performance
                PerformancePage(statsController.currentUserModel.value),
                // Fixture
                FixtureSection(
                  tooltipController: tooltipController,
                  userModel: statsController.currentUserModel.value,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget buildSessionCompletedMeter() {
    return FutureBuilder<FetchPlayerHomeBookingResponse>(
        future: fetchPlayerHomeBooking(userModel!.getAuthToken()),
        builder: (context, snapshot) {
          List<PlayerHomeBookingDetails>? bookingDetails = [];
          if (snapshot.data != null) {
            var s = snapshot.data;
            if (s?.status ?? false) {
              bookingDetails = s!.details;
            }
          }

          int completed = 0;
          var tempList = bookingDetails!.toList();
          for (var item in tempList) {
            if ("${item.data!.status}" == "completed") {
              completed += 1;
            }
          }

          return SessionCompletedMeter(
              completed: completed, total: tempList.length);
        });
  }

  Row buildTab() {
    return Row(
      children: List.generate(
        3,
        (i) => Obx(
          () => Expanded(
            child: InkWell(
              onTap: () {
                statsController.currentTabIndex.value = i;
              },
              child: Container(
                decoration: i == statsController.currentTabIndex.value
                    ? BoxDecoration(color: Color.fromRGBO(28, 67, 138, 1))
                    : BoxDecoration(
                        border:
                            Border.all(color: Color.fromRGBO(28, 67, 138, 1)),
                      ),
                height: 55,
                child: Center(
                  child: mediumText(
                    l[i],
                    color: statsController.currentTabIndex.value == i
                        ? white
                        : Color.fromRGBO(28, 67, 138, 1),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

    // HoursOfTrainingStats(performanceStat: performanceStat);
  }

  Widget buildHome() {
    return FutureBuilder<FetchPlayerStatsResponse>(
        future: fetchPlayerStatsData(
          token: statsController.currentUserModel.value.getAuthToken()!,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
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

          var playerStatsData = snapshot.data;
          //HoursOfTrainingStats
          var hoursOfTrainingData;

          if (playerStatsData?.performanceStats != null &&
              playerStatsData!.performanceStats!.isNotEmpty /* != {}*/) {
            PlayerPerformanceStat p =
                playerStatsData.performanceStats!["Hours of Training"]!;
            hoursOfTrainingData = HoursOfTrainingStats(
                p.getMonthlyData().values.first,
                (p.target ?? 0 / 52)); // p as HoursOfTrainingStats;
          } else {
            print("Data is empty....");
            hoursOfTrainingData = HoursOfTrainingStats([], 0);
          }
          PlayerPerformanceStat? sessionsCompletedData;
          if (playerStatsData?.performanceStats != null &&
              playerStatsData!.performanceStats!.isNotEmpty /* != {}*/) {
            sessionsCompletedData =
                playerStatsData.performanceStats!["Sessions Completed"];
          } else {
            sessionsCompletedData =
                PlayerPerformanceStat(goal: "Sessions Completed", target: 0.0);
          }
          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16,
              ),
              child: Column(
                children: [
                  //Hours of Training
                  StatItem(
                    hideTop: true,
                    charts: [
                      Container(
                        height: 280,
                        child: HoursOfTrainingGraph(
                          statsData: hoursOfTrainingData,
                        ),
                      ),
                    ],
                    targetType: TargetType.target_train_hr,
                    title: "Hours of Training",
                    current: [10, 40, 520],
                    target: [100, 400, 5200],
                    img: "assets/stats11.png",
                    hidetarget: true,
                    hideAddRecord: true,
                  ),
                  // SessionsCompleted
                  /*StatItem(
                        charts: [
                          Container(
                            height: 250,
                            child: Charts(
                              target: sessionsCompletedData?.target ?? 0,
                              period: Period.WEEKLY,
                              weeklyData: sessionsCompletedData?.weekly ?? [],
                            ),
                          ),
                          Container(
                            height: 250,
                            child: Charts(
                              target: sessionsCompletedData?.target ?? 0,
                              period: Period.MONTHLY,
                              monthlyData: sessionsCompletedData?.monthly ?? [],
                            ),
                          ),
                          Container(
                            height: 250,
                            child: Charts(
                              target: sessionsCompletedData?.target ?? 0,
                              period: Period.YEARLY,
                              yearlyData: sessionsCompletedData?.yearly ?? [],
                            ),
                          ),
                        ],
                        targetType: TargetType.target_session,
                        title: "Sessions Completed",
                        current: [10, 40, 520],
                        target: [100, 400, 5200],
                        hidetarget: true,
                   hideAddRecord: true,
                   img: "assets/stats12.png",
                      ),*/

                  FutureBuilder<PreviousHomeStats?>(
                      future: getStatsHomeStateLocal(),
                      builder: (context, snapshot) {
                        PreviousHomeStats? homeStats = snapshot.data;
                        print(
                            "PreviousHomeStats ${homeStats?.toJson().toString()}");
                        print(
                            "PreviousHomeStats 22 ${statsController.currentUserModel.value.getUser().details?.id} "
                            "${userModel?.getUser().details?.id}");
                        if (homeStats != null) {
                          List homeStatsList = homeStats.statsIds!.toList();

                          List<PlayerPerformanceStat>? stats = playerStatsData
                              ?.performanceStats?.values
                              .where((element) =>
                                  element.goal != "Hours of Training" &&
                                  element.goal != "Sessions Completed")
                              .toList();
                          print("homeStatsList ${stats?.length}");

                          return Consumer<UIProvider>(
                              builder: (c, provider, widget) {
                            int maxStats = provider.isSubScribed()
                                ? (stats?.length ?? 0)
                                : (stats?.length ?? 0) > 4
                                    ? 4
                                    : (stats?.length ?? 0);

                            return Column(
                              children: homeStatsList.length != 0
                                  ? List.generate(homeStatsList.length,
                                      (index) {
                                      int? statId = homeStatsList[index];
                                      for (int i = 0;
                                          i < stats!.length && maxStats > 0;
                                          i++) {
                                        if (stats[i].id == statId) {
                                          maxStats = maxStats - 1;
                                          return PerformanceStatItem(
                                            performanceStat: stats[i],
                                            ind: index,
                                            showButton3: false,
                                            hideAddRecord: true,
                                            deleteItem: (int? statID, BuildContext context) {
                                              deleteItem(statId, context);
                                            },
                                          );
                                        }
                                      }
                                      return verticalSpace(height: 2);
                                    })
                                  : [],
                            );
                          });
                        } else
                          return verticalSpace(height: 4);
                      }),
                ],
              ),
            ),
          ]);
        });
  }

  Future<List<PerformanceStatItem>> buildHomeStats(int userId) async {
    PreviousHomeStats homeStats =
        await (getStatsHomeStateLocal() as FutureOr<PreviousHomeStats>);
    toast(homeStats.toJson().toString());
    toast("$userId");
    if (homeStats.userId == userId) {
      List<int?> homeStatsList = homeStats.statsIds!.toList() as List<int?>;
      List.generate(homeStats.statsIds!.length, (index) {});
      List.generate(homeStats.statsIds!.length, (index) {
        int? statId = homeStatsList[index];
        for (int i = 0; i < performanceStats.length; i++) {
          if (performanceStats[i].id == statId)
            return PerformanceStatItem(
              performanceStat: performanceStats[i],
              ind: index,
              deleteItem: (int? statID, BuildContext context) {
                // deleteItem(statId, context);
              },
            );
        }
      });
    }
    return [];
  }

  StatItem buildGoalsScoredGraph() {
    return StatItem(
      charts: [
        Container(
          child: GoalsScoredGraph(
            current: 5,
            target: 2,
            start: "July 16, 2020",
            end: "July 24, 2020",
          ),
        ),
        Container(
          child: GoalsScoredGraph(
            current: 5,
            target: 10,
            start: "July 16, 2020",
            end: "July 24, 2020",
          ),
        ),
        Container(
          child: GoalsScoredGraph(
            current: 50,
            target: 100,
            start: "July 16, 2020",
            end: "July 24, 2020",
          ),
        ),
      ],
      targetType: TargetType.target_goal_scored,
      title: "Goals Scored",
      current: [10, 40, 520],
      target: [100, 400, 5200],
      img: "assets/stats13.png",
    );
  }

  deleteItem(int? statID, BuildContext context) {
    print("deleting statItem");
    if (statID != null) {

      showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure you want to delete this stat?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Future.sync(() async {
                      var removed = await deleteStatsItemHomeStateLocal(statID);
                      if (removed) {
                        print("Stat item $statID removed");
                      }
                    });
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });
    }
  }
}

class StatsPageTabs extends StatelessWidget {
  //TODO: Remember to finish writing this refactor once you're done implementing the API

  final List<String> tabTitles;
  final Function onTabSelection;
  final StatsController statsController = Get.find<StatsController>();

  StatsPageTabs(
      {required this.onTabSelection,
      this.tabTitles = const ["Home", "Performance", "Fixtures"]}) {
    statsController.currentTabIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (i) => Obx(() => Expanded(
              child: InkWell(
                onTap: () {
                  statsController.currentTabIndex.value = i;
                  onTabSelection(i);
                },
                child: Container(
                  decoration: i == statsController.currentTabIndex.value
                      ? BoxDecoration(color: Color.fromRGBO(28, 67, 138, 1))
                      : BoxDecoration(
                          border:
                              Border.all(color: Color.fromRGBO(28, 67, 138, 1)),
                        ),
                  height: 55,
                  child: Center(
                    child: mediumText(
                      tabTitles[i],
                      color: statsController.currentTabIndex.value == i
                          ? white
                          : Color.fromRGBO(28, 67, 138, 1),
                      size: 16,
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
