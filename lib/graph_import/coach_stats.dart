import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/graph_import/graphs/charts_adapters/charts_index_sample.dart';
import 'package:cme/graph_import/graphs/earnings/earnings_chart.dart';
import 'package:cme/network/coach_stat/coach_stats_data.dart';
import 'package:cme/network/coach_stat/coach_stats_network_helper.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'stat_item.dart';

class CoachStatsPage extends StatefulWidget {
  final UserModel? userModel;

  const CoachStatsPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _CoachStatsPageState createState() => _CoachStatsPageState();
}

class _CoachStatsPageState extends State<CoachStatsPage> {
  Future<CoachStatisticsData>? statisticsData;
  UserModel? userModel;

  List<String> l = [
    "Weekly",
    "Month",
    "Year",
  ];
  int catIndex = 0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        setState(() {});
      },
      child: ScopedModelDescendant<UserModel>(builder: (i, j, model) {
        userModel = model;
        return buildBaseScaffold(
            color: themeBkg,
            bottomPadding: 4,
            context: context,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: buildBody(model),
            ),
            title: "Stats",
            hideBack: true);
      }),
    );
  }

  Widget buildBody(UserModel userModel) {
    return ListView(
      children: [
        FutureBuilder(
            future: statisticsData,
            builder: (context, snapshot) {
              CoachStatisticsData? data = snapshot.data as CoachStatisticsData?;
              var targetEarnings = (data != null && data.earningsTarget != null)
                  ? data.earningsTarget!
                  : 0.0;
              var currentEarnings =
                  (data != null)
                      ? data.earningsCurrent
                      : 0.0;
              return StatItem(
                title: "Your Earnings",
                userToken: userModel.getAuthToken(),
                current: [
                  currentEarnings / 52,
                  currentEarnings / 12,
                  currentEarnings
                ],
                target: [
                  targetEarnings / 52,
                  targetEarnings / 12,
                  targetEarnings
                ],
                img: "assets/stat_earning.png",
                targetType: TargetType.target_earning,
                charts: [
                  Container(
                    child: EarningsChart(
                      period: Period.WEEKLY,
                      weeklyEarnings: data != null
                          ? data.weeklyEarning
                          : [],
                    ), // TODO: Add real line Graph here for earnings
                  ),
                  Container(
                    child: EarningsChart(
                      period: Period.MONTHLY,
                      monthlyEarnings:
                          data != null
                              ? data.monthlyEarning
                              : [],
                    ), // TODO: Add real line Graph here for Monthly earnings
                  ),
                  Container(
                    child: EarningsChart(
                      period: Period.YEARLY,
                      yearlyEarnings: data != null
                          ? data.yearlyEarning
                          : [],
                    ), // TODO: Add real line Graph here for Yearly earnings
                  ),
                ],
              );
            }),
        verticalSpace(height: 16),
        FutureBuilder(
            future: statisticsData,
            builder: (context, snapshot) {
              CoachStatisticsData? data =
                  (snapshot != null ? snapshot.data : null) as CoachStatisticsData?;
              var targetSessionCompleted =
                  (data != null && data.sessionCompletedTarget != null)
                      ? data.sessionCompletedTarget!
                      : 0.0;
              var currentSessionCompleted =
                  (data != null)
                      ? (data.sessionsCompletedCurrent)
                      : 0.0;
              return StatItem(
                  userToken: userModel.getAuthToken(),
                  charts: [
                    Container(
                      child: Charts(
                        period: Period.WEEKLY,
                        weeklyData: data != null
                            ? data.weeklySessionsCompleted != null
                                ? data.weeklySessionsCompleted
                                : []
                            : [],
                      ), // TODO: Add real line Graph here for earnings
                    ),
                    Container(
                      child: Charts(
                        period: Period.MONTHLY,
                        monthlyData: data != null
                            ? data.monthlySessionsCompleted
                            : [],
                      ), // TODO: Add real line Graph here for Monthly earnings
                    ),
                    Container(
                      child: Charts(
                        period: Period.YEARLY,
                        yearlyData:
                            data != null
                                ? data.yearlySessionsCompleted
                                : [],
                      ), // TODO: Add real line Graph here for Yearly earnings
                    ),
                  ],
                  targetType: TargetType.target_session,
                  title: "Sessions Completed",
                  current: [
                    currentSessionCompleted / 52,
                    currentSessionCompleted / 12,
                    currentSessionCompleted
                  ],
                  target: [
                    targetSessionCompleted / 52,
                    targetSessionCompleted / 12,
                    targetSessionCompleted
                  ],
                  img: "assets/stats_completed.png");
            }),
        verticalSpace(height: 16),
        FutureBuilder(
            future: statisticsData,
            builder: (context, snapshot) {
              CoachStatisticsData? data = snapshot.data as CoachStatisticsData?;
              var hoursCompletedTarget =
                  (data != null && data.hoursCompletedTarget != null)
                      ? data.hoursCompletedTarget
                      : 0.0;
              var hoursCompletedCurrent =
                  (data != null)
                      ? data.hoursCompletedCurrent
                      : 0.0;
              return StatItem(
                  userToken: userModel.getAuthToken(),
                  onEditStats: (value) {
                    setState(() {
                      hoursCompletedTarget = value;
                    });
                    toast("Updated Successfully");
                  },
                  charts: [
                    Container(
                      child: Charts(
                        period: Period.WEEKLY,
                        weeklyData:
                            data != null
                                ? data.weeklySessionsCompleted
                                : [],
                      ), // TODO: Add real line Graph here for earnings
                    ),
                    Container(
                      child: Charts(
                        period: Period.MONTHLY,
                        monthlyData: data != null
                            ? data.monthlySessionsCompleted
                            : [],
                      ), // TODO: Add real line Graph here for Monthly earnings
                    ),
                    Container(
                      child: Charts(
                        period: Period.YEARLY,
                        yearlyData:
                            data != null
                                ? data.yearlySessionsCompleted
                                : [],
                      ), // TODO: Add real line Graph here for Yearly earnings
                    ),
                  ],
                  targetType: TargetType.target_hour,
                  title: "Hours Completed",
                  current: [
                    hoursCompletedCurrent / 52,
                    hoursCompletedCurrent / 12,
                    hoursCompletedCurrent
                  ],
                  target: [
                    hoursCompletedTarget! / 52,
                    hoursCompletedTarget! / 12,
                    hoursCompletedTarget
                  ],
                  img: "assets/stats_hours.png");
            }),
        verticalSpace(height: 16),
        FutureBuilder(
            future: statisticsData,
            builder: (context, snapshot) {
              CoachStatisticsData? data = snapshot.data as CoachStatisticsData?;
              var myRating = data?.rating;
              return Container(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent.withOpacity(.8),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            boldText("My Rating",
                                color: Colors.white, size: 24),
                            verticalSpace(height: 16),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              direction: Axis.vertical,
                              children: [
                                SmoothStarRating(
                                  color: Color.fromRGBO(252, 194, 7, 1),
                                  allowHalfRating: true,
                                  size: 48,
                                  rating: myRating ?? 0.0,
                              //    isReadOnly: true,
                                  borderColor: Color.fromRGBO(252, 194, 7, 1),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: lightText("(300 user rating)",
                                          color: white)),
                                ),
                              ],
                            ),
                            verticalSpace(height: 16),
                          ],
                        ),
                      ),
                      Container(
                        color: white,
                        width: double.infinity,
                        height: 1,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(color:white )
                        ),
                           onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                MaterialIcons.open_in_new,
                                size: 12,
                              ),
                              horizontalSpace(),
                              Text("Share"),
                            ],
                          )),
                    ],
                  ),
                ),
                // height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/stat_rating.png"),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                    // colorFilter: ColorFilter.mode(deepBlue, BlendMode.dstOver)
                  ),
                ),
              );
            }),
        verticalSpace(height: 95),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (statisticsData == null) loadStatsData();
  }

  loadStatsData() async {
    // CoachStatisticsData stats = await fetchCoachStats(
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNjA0NTQwNjg5LCJleHAiOjE2MDQ2MjcwODl9.vNiuKj2mGrqOzUgS64aB-bY9omiyDDzn2RY8KSwzjdY');
    // if (stats.status) {
    //   statisticsData = stats;
    // }

    statisticsData = fetchCoachStats(widget.userModel!.getAuthToken());
  }
}
