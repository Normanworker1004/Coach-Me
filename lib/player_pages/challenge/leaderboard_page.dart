import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_fixtures_leaderboard_response.dart';
import 'package:cme/model/player_leaderboard_challenge_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/fixtures.dart';
import 'package:cme/network/leageue_table.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

class LeaderBoardPage extends StatefulWidget {
  final UserModel? userModel;

  const LeaderBoardPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  UserModel? userModel;
  int catIndex = 0;
  int catIndex2 = 0;
  List<LeagueChallengeSubDetails>? details;
  PlayerPositionData? currentPlayerData;
  List<LeagueChallengeSubDetails>? details2;
  PlayerPositionData? currentPlayerData2;
  List<LeagueChallengeSubDetails>? details3;
  PlayerPositionData? currentPlayerData3;

  List<FixturesDetails>? fixturesDetails;
  ResponseData? fixturesUserdata;

  List<String> l = [
    "Weekly",
    "Month",
    "All Time",
  ];

  @override
  void initState() {
    super.initState();

    initAll();
  }

  initAll() async {
    userModel = widget.userModel;
    FetchFixturesLeaderBoardResponse b =
        await fetchFixturesLeaderBoard(token: userModel!.getAuthToken()!);
    if (b.status!) {
      fixturesDetails = b.details;
      fixturesUserdata = b.responseData;
    }
    setState(() {});

    PlayerLeaderBoardResponse response = await fetchPlayerLeaderBoard(
        isWeekly: "week", token: userModel!.getAuthToken()!);
    if (response.status!) {
      details = response.details;
      currentPlayerData = response.playerPositionData;
    }
    setState(() {});

    PlayerLeaderBoardResponse response2 = await fetchPlayerLeaderBoard(
        isWeekly: "month", token: userModel!.getAuthToken()!);
    if (response2.status!) {
      details2 = response2.details;
      currentPlayerData2 = response2.playerPositionData;
    }
    setState(() {});

    PlayerLeaderBoardResponse response3 = await fetchPlayerLeaderBoard(
        isWeekly: "all time", token: userModel!.getAuthToken()!);

    if (response3.status!) {
      details3 = response3.details;
      currentPlayerData3 = response3.playerPositionData;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        textColor: Colors.white,
        context: context,
        color: Color(0xFF224782),
        body: PageView(
          children: <Widget>[
            buildFixtures(),
            buildChallenge(),
          ],
        ),
        title: "League Table",
        rightIconWidget: filterIcon());
  }

//TODO (User real data for fixtures)
  Widget buildFixtureTableRow(
    int pos, {
    required FixturesDetails ld,
    textColor: Colors.black,
    bgColor: Colors.white,
    Userdetails? userDetails,
    ResponseData? userData,
  }) {
    Userdetails u =
        //userModel.getUserDetails();

        userDetails == null ? ld.fixtureuserdetails! : userDetails;
    int? totalApp = ld.score1;
    int? goals = ld.score2;
    int? assist = ld.score3;
    int? clSheet = ld.score4;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 4, top: 16, bottom: 16, right: 4),
            child: Row(
              children: <Widget>[
                rLightText(
                  "$pos.",
                  color: textColor,
                ),
                Align(
                  child: Transform.rotate(
                    angle: m.pi * -.5,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.green,
                      size: 8,
                    ),
                  ),
                ),
                horizontalSpace(width: 3),
                CircularNetworkImage(
                  imageUrl: "${photoUrl + u.profilePic!}",
                  size: 32,
                ),
                horizontalSpace(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      lightText(
                        "${u.name}",
                        color: textColor,
                      ),
                      lightText(
                        "${getSportLevel(u, sport: u.sport!.sport!.first)}",
                        color: textColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      boldText("$totalApp", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      boldText("$goals", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      boldText("$assist", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      boldText("$clSheet", color: textColor, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        verticalSpace(),
      ],
    );
  }

  Widget buildFixtures() {
    return Column(
      children: <Widget>[
        Center(child: boldText("Fixtures", color: Colors.white)),
        verticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  catIndex2 = index;
                });
              },
              child: catIndex2 == index
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: lightText(
                          "Weekly".toUpperCase(),
                          color: Colors.white,
                        ),
                      ),
                    )
                  : lightText(
                      "Weekly".toUpperCase(),
                      color: Colors.white,
                    ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.transparent.withOpacity(.3),
          ),
          child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                width: 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: lightText(
                        "APP".toUpperCase(),
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: lightText(
                        "GOALS".toUpperCase(),
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: lightText("ASSISTS".toUpperCase(),
                          color: Colors.white, size: 14),
                    ),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: lightText(
                        "CLN ST".toUpperCase(),
                        color: Colors.white,
                        size: 12,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: fixturesDetails == null
              ? Container(child: Center(child: CircularProgressIndicator()))
              : ListView(
                  children: List.generate(
                    fixturesDetails!.length > 10 ? 10 : fixturesDetails!.length,
                    (index) {
                      if (fixturesUserdata!.status!) {
                        var myPos = fixturesUserdata!.result!;
                        var total = fixturesDetails!.length;
                        if (myPos <= total) {
                          if (index == myPos - 1) {
                            return buildFixtureTableRow(
                              index + 1,
                              ld: fixturesDetails![index],
                              userData: fixturesUserdata,
                              userDetails: userModel!.getUserDetails(),
                              textColor: Colors.black,
                              bgColor: Colors.white,
                            );
                          }
                        } else {
                          if (index == total - 1) {
                            return buildFixtureTableRow(
                              index + 1,
                              ld: fixturesDetails![index],
                              userData: fixturesUserdata,
                              userDetails: userModel!.getUserDetails(),
                              textColor: Colors.black,
                              bgColor: Colors.white,
                            );
                          }
                        }
                      }
                      return buildFixtureTableRow(
                        index + 1,
                        ld: fixturesDetails![index],
                        userData: fixturesUserdata,
                        textColor: Colors.white,
                        bgColor: Colors.transparent.withOpacity(.3),
                      );
                    },
                  ),
                ),
        ),
        // buildTableItemWhite()
      ],
    );
  }

  Widget buildChallenge() {
    return Column(
      children: <Widget>[
        Center(child: boldText("Challenge", color: Colors.white)),
        verticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  catIndex = index;
                });
              },
              child: catIndex == index
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: lightText(
                          l[index].toUpperCase(),
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: lightText(
                        l[index].toUpperCase(),
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                Container(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: lightText(
                          "PLD",
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: lightText(
                          "W",
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: lightText(
                          "D",
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: lightText(
                          "L",
                          color: Colors.white,
                          size: 14,
                          maxLines: 1,
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: lightText(
                          "PTS",
                          color: Colors.white,
                          size: 14,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: IndexedStack(
          children: [
            details == null
                ? Container(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()))
                : buildChallengeTable(details!, currentPlayerData),
            details2 == null
                ? Container(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()))
                : buildChallengeTable(details2!, currentPlayerData2),
            details3 == null
                ? Container(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()))
                : buildChallengeTable(details3!, currentPlayerData3),
          ],
        )),
      ],
    );
  }

  Widget buildChallengeTable(List<LeagueChallengeSubDetails> details,
      PlayerPositionData? currentPlayerData) {
    return ListView(
      children: List.generate(details.length, (index) {
        if (currentPlayerData!.isPlayerFound!) {
          var myPos = currentPlayerData.myPosition!;
          var total = details.length;
          if (myPos <= total) {
            if (index == myPos - 1) {
              return buildChallengeTableRow(
                index + 1,
                userDetails: userModel!.getUserDetails(),
                userData: currentPlayerData.userData,
                bgColor: Colors.white,
                textColor: Colors.black,
              );
            }
          } else {
            if (index == total - 1) {
              return buildChallengeTableRow(
                index + 1,
                userDetails: userModel!.getUserDetails(),
                userData: currentPlayerData.userData,
                bgColor: Colors.white,
                textColor: Colors.black,
              );
            }
          }
        }

        return buildChallengeTableRow(
          index + 1,
          ld: details[index],
          textColor: Colors.white,
          bgColor: Colors.transparent.withOpacity(.3),
        );
      }),
    );
  }

  Widget buildChallengeTableRow(
    int pos, {
    LeagueChallengeSubDetails? ld,
    textColor: Colors.black,
    bgColor: Colors.white,
    Userdetails? userDetails,
    Userdata? userData,
  }) {
    Userdetails u = userDetails == null ? ld!.userdetails! : userDetails;
    var win = userDetails == null ? ld!.challengeWin! : userData!.challengeWin!;
    var draw = userDetails == null ? ld!.challengeDraw! : userData!.challengeDraw!;
    var loss = userDetails == null ? ld!.challengeLoss! : userData!.challengeLoss!;
    int totalPlayed = win + draw + loss;
    int totalPoint = (win * 3) + draw;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 4, top: 16, bottom: 16, right: 4),
            child: Row(
              children: <Widget>[
                rLightText(
                  "$pos.",
                  color: textColor,
                ),
                Align(
                  child: Transform.rotate(
                    angle: m.pi * -.5,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.green,
                      size: 8,
                    ),
                  ),
                ),
                horizontalSpace(width: 3),
                CircularNetworkImage(
                  imageUrl: "${photoUrl + u.profilePic!}",
                  size: 32,
                ),
                horizontalSpace(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      lightText(
                        "${u.name}",
                        color: textColor,
                      ),
                      lightText(
                        "${getSportLevel(u, sport: u.sport!.sport!.first)}",
                        color: textColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      rBoldText("$totalPlayed", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      rBoldText("$win", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      rBoldText("$draw", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      rBoldText("$loss", color: textColor, size: 12),
                      horizontalSpace(width: 4),
                      rBoldText("$totalPoint", color: textColor, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        verticalSpace(),
      ],
    );
  }
}
