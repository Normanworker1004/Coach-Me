import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/coach_leader_board_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/leageue_table.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/functions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

class CoachLeaderBoardPage extends StatefulWidget {
  final UserModel? userModel;

  const CoachLeaderBoardPage({Key? key, required this.userModel})
      : super(key: key);
  @override
  _CoachLeaderBoardPageState createState() => _CoachLeaderBoardPageState();
}

class _CoachLeaderBoardPageState extends State<CoachLeaderBoardPage> {
  int catIndex = 0;
  UserModel? userModel;
  List<LeagueSubDetails>? details;
  CoachPositionData? currentCoachData;
  List<LeagueSubDetails>? details2;
  CoachPositionData? currentCoachData2;
  List<LeagueSubDetails>? details3;
  CoachPositionData? currentCoachData3;

  initAll() async {
    userModel = widget.userModel;
    CoachLeaderBoardResponse response = await fetchCoachLeaderBoard(
        isWeekly: "week", token: userModel!.getAuthToken()!);
    if (response.status!) {
      details = response.details;
      currentCoachData = response.coachPositionData;
    }
    setState(() {});

    CoachLeaderBoardResponse response2 = await fetchCoachLeaderBoard(
        isWeekly: "month", token: userModel!.getAuthToken()!);
    if (response2.status!) {
      details2 = response2.details;
      currentCoachData2 = response2.coachPositionData;
    }
    setState(() {});

    CoachLeaderBoardResponse response3 = await fetchCoachLeaderBoard(
        isWeekly: "all time", token: userModel!.getAuthToken()!);

    if (response3.status!) {
      details3 = response3.details;
      currentCoachData3 = response3.coachPositionData;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initAll();
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        backgroundImage: "assets/table_bg.png",
        textColor: Colors.white,
        context: context,
        color: Colors.yellow.withOpacity(1),
        body: PageView(
          children: <Widget>[
            buildFixtures(),
            // buildChallenge(),
          ],
        ),
        title: "Coaches Performance",
        rightIconWidget: filterIcon());
  }

  Widget buildFixtures() {
    List<String> l = [
      "Weekly",
      "Month",
      "All Time",
    ];
    return Column(
      children: <Widget>[
        // Center(child: boldText("Fixtures", color: Colors.white)),
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
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: lightText(
                          l[index].toUpperCase(),
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    )
                  : lightText(
                      l[index].toUpperCase(),
                      color: Colors.white,
                      size: 14,
                    ),
            ),
          ),
        ),
        verticalSpace(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.transparent.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                Container(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: lightText(
                          "Sessions".toUpperCase(),
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: Center(
                          child: lightText(
                            "Rating".toUpperCase(),
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: lightText(
                          "Points".toUpperCase(),
                          color: Colors.white,
                          size: 10,
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
            index: catIndex,
            children: [
              details == null
                  ? Container(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()))
                  : buildTableList(currentCoachData, details!),
              details2 == null
                  ? Container(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()))
                  : buildTableList(currentCoachData2, details2!),
              details3 == null
                  ? Container(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()))
                  : buildTableList(currentCoachData3, details3!),
            ],
          ),
        ),
      ],
    );
  }

  buildTableList(
      CoachPositionData? currentCoachData, List<LeagueSubDetails> details) {
    return ListView(
      children: List.generate(details.length, (index) {
        if (currentCoachData!.coachFound!) {
          var myPos = currentCoachData.myPosition!;
          var total = details.length;
          if (myPos <= total) {
            if (index == myPos - 1) {
              return buildTableItemWhite(index + 1, currentCoachData.userdata!,
                  userModel!.getUserDetails()!);
            }
          } else {
            if (index == total - 1) {
              return buildTableItemWhite(
                currentCoachData.myPosition,
                currentCoachData.userdata!,
                userModel!.getUserDetails()!,
              );
            }
          }
        }

        return buildTableItem(index + 1, details[index]);
      }),
    );
  }

  Widget buildTableItem(int pos, LeagueSubDetails ld) {
    Userdetails u = ld.userdetails!;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent.withOpacity(.3),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 6, top: 16, bottom: 16, right: 4),
            child: Row(
              children: <Widget>[
                rLightText(
                  "$pos.",
                  color: Colors.white,
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
                        color: Colors.white,
                      ),
                      lightText(
                        "${getCoachSportLevel(u, sport: u.sport!.sport!.first)}",
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      rBoldText("${ld.exSession}",
                          color: Colors.white, size: 14),
                      horizontalSpace(width: 4),
                      rBoldText("${ld.exRating}",
                          color: Colors.white, size: 14),
                      horizontalSpace(width: 4),
                      rBoldText("${ld.exPoints}",
                          color: Colors.white, size: 14),
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

  Widget buildTableItemWhite(int? pos, Userdata ld, Userdetails u) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 6, top: 16, bottom: 16, right: 4),
            child: Row(
              children: <Widget>[
                rLightText(
                  "$pos.",
                  color: Colors.black,
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
                        color: Colors.black,
                      ),
                      lightText(
                        "${getCoachSportLevel(u, sport: u.sport!.sport!.first)}",
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      rBoldText("${ld.exSession}",
                          color: Colors.black, size: 14),
                      horizontalSpace(width: 4),
                      rBoldText("${ld.exRating}",
                          color: Colors.black, size: 14),
                      horizontalSpace(width: 4),
                      rBoldText("${ld.exPoints}",
                          color: Colors.black, size: 14),
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

  Widget buildTableItem2() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent.withOpacity(.3),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 4, top: 16, bottom: 16, right: 4),
            child: Row(
              children: <Widget>[
                lightText(
                  "1.",
                  color: Colors.white,
                ),
                Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                  size: 8,
                ),
                horizontalSpace(width: 3),
                CircularImage(size: 32),
                horizontalSpace(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      lightText(
                        "Christ maerry",
                        color: Colors.white,
                      ),
                      lightText(
                        "Semi Pro",
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      boldText("83", color: Colors.white, size: 14),
                      horizontalSpace(width: 4),
                      boldText("83", color: Colors.white, size: 14),
                      horizontalSpace(width: 4),
                      boldText("83", color: Colors.white, size: 14),
                      horizontalSpace(width: 4),
                      boldText("83", color: Colors.white, size: 14),
                      horizontalSpace(width: 4),
                      boldText("832", color: Colors.white, size: 14),
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

  Widget buildChallenge() {
    return ListView(
      children: <Widget>[
        Center(child: boldText("Challenge", color: Colors.white)),
        verticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (index) => catIndex == index
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.transparent.withOpacity(.3),
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
                        child: lightText("L", color: Colors.white, size: 14),
                      ),
                      horizontalSpace(width: 4),
                      Expanded(
                        child: lightText(
                          "D",
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
        Wrap(
          children: List.generate(10, (index) => buildTableItem2()),
        ),
      ],
    );
  }
}
