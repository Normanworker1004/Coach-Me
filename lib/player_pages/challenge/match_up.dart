import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_challenge_booking_response.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/network/player/challenge.dart';
import 'package:cme/player_pages/challenge/match_up_2.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/player_points.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengeMAtchUpPage extends StatefulWidget {
  final Userdetails? player1details;
  final Userdetails? player2details;
  final bool isHost;

  const ChallengeMAtchUpPage({
    Key? key,
    required this.player1details,
    required this.player2details,
    required this.isHost,
  }) : super(key: key);
  @override
  _ChallengeMAtchUpPageState createState() => _ChallengeMAtchUpPageState();
}

class _ChallengeMAtchUpPageState extends State<ChallengeMAtchUpPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  Userdetails? player1details;
  Userdetails? player2details;
  late bool isHost;
  late UserModel userModel;
  late ChallengeBookingDetails chaDetails;

  List<TextEditingController?> controllers1 = List<TextEditingController?>.filled(10, null, growable: false);
  List<TextEditingController?> controllers2 = List<TextEditingController?>.filled(10, null, growable: false);

  bool isPlayer1Winer = false;

  processEndofChallenge(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    var winA = 0;
    var winB = 0;

    for (var i = 0; i < chaDetails.tryout!; i++) {
      if (int.tryParse(controllers1[i]!.text)! >
          int.tryParse(controllers2[i]!.text)!) {
        winA += 1;
      } else if (int.tryParse(controllers1[i]!.text)! <
          int.tryParse(controllers2[i]!.text)!) {
        winB += 1;
      }
    }
    userModel.setShowChallengeResult(true);
    isPlayer1Winer = winA > winB;
    uploadScores(context);
  }

  uploadScores(BuildContext context) async {
    var r = await uploadChallengeScores(userModel.getAuthToken(),
        player1: player1details!.id,
        player2: player2details!.id,
        score1: List.generate(
            controllers1.length, (index) => controllers1[index]!.text),
        score2: List.generate(
            controllers2.length, (index) => controllers2[index]!.text),
        win: isPlayer1Winer ? player1details!.id : player2details!.id,
        loose: !isPlayer1Winer ? player1details!.id : player2details!.id,
        challengeId: chaDetails.id);

    showSnack(context, "${r.message}");
  }

  @override
  void initState() {
    super.initState();
    player1details = widget.player1details;
    player2details = widget.player2details;
    isHost = widget.isHost;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (i, j, model) {
        userModel = model;
        chaDetails = userModel.getCurrentchallenge();
        controllers1 = userModel.getmatchUpP1Contoller();
        controllers2 = userModel.getmatchUpP2Contoller();
        return Scaffold(
          key: _key,
          body: buildBaseScaffold(
            color: deepBlue,
            textColor: white,
            context: context,
            body: buildBody(context),
            lrPadding: 0,
            title: "Entry Log",
          ),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildTop(),
        Expanded(child: buildScoreBoard(context)),
        Divider(color: white),
        verticalSpace(height: 32),
        Visibility(
          visible: userModel.getShowChallengeResult(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildWinner(
                  imgUrl: photoUrl +
                      "${(isPlayer1Winer ? player1details!.profilePic : player1details!.profilePic)}",
                  name: isPlayer1Winer
                      ? player1details!.name
                      : player1details!.name,
                ),
                verticalSpace(height: 32),
                proceedButton(
                  text: "Rematch",
                  onPressed: () {
                    userModel.setmatchUpP1Contoller(List.generate(
                        chaDetails.tryout!,
                        (index) => TextEditingController(text: "")));
                    userModel.setmatchUpP2Contoller(List.generate(
                        chaDetails.tryout!,
                        (index) => TextEditingController(text: "")));
                    userModel.setShowChallengeResult(false);
                  },
                ),
                verticalSpace(),
                borderProceedButton(
                    text: "Report",
                    onPressed: () {},
                    color: Color.fromRGBO(182, 9, 27, 1))
              ],
            ),
          ),
        ),
        Visibility(
          visible: !userModel.getShowChallengeResult(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: proceedButton(
                text: "Contact Player's Next to Kin",
                onPressed: () {
                  pushRoute(context, ChallengeMAtchUpPageFinal());
                }),
          ),
        )
      ],
    );
  }

  Widget buildWinner({imgUrl, name}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularNetworkImage(
          imageUrl: "$imgUrl",
          size: 100,
        ),
        horizontalSpace(),
        Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            boldText(
              "$name",
              color: white,
            ),
            boldText(
              "Won",
              size: 14,
              color: Color.fromRGBO(182, 9, 27, 1),
            ),
          ],
        )
      ],
    );
  }

  TextStyle textStyle = TextStyle(color: white);

  Widget buildScoreBoard(BuildContext context) {
    return Column(
      children: <Widget>[
        boldText(
          "Best out of ${chaDetails.tryout}: ${chaDetails.gameplay}",
          color: white,
          size: 18,
        ),
        DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: mediumText(
                'No',
                color: white,
              ),
            ),
            DataColumn(
              label: Expanded(
                child: mediumText(
                  isHost ? 'You' : "${player1details!.name}",
                  color: white,
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: mediumText(
                  !isHost ? 'You' : "${player2details!.name}",
                  color: white,
                ),
              ),
            ),
          ],
          rows: List.generate(
            chaDetails.tryout!,
            (index) {
              var c1 = controllers1[index]!;
              var c2 = controllers2[index]!;
              return DataRow(
                cells: <DataCell>[
                  DataCell(mediumText(
                    '${index + 1}.',
                    color: white,
                  )),
                  DataCell(
                    dataInput(
                      isWinner: (int.tryParse("${c1.text}") ?? 0) >
                          (int.tryParse("${c2.text}") ?? 0),
                      controller: c1,
                      onChanged: (c) {
                        userModel.setmatchUpP1Contoller(controllers1);
                      },
                    ),
                  ),
                  DataCell(
                    dataInput(
                      isWinner: (int.tryParse("${c1.text}") ?? 0) <
                          (int.tryParse("${c2.text}") ?? 0),
                      controller: c2,
                      onChanged: (c) {
                        userModel.setmatchUpP2Contoller(controllers2);

                        if (index + 1 == chaDetails.tryout) {
                          processEndofChallenge(context);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget dataInput({controller, onChanged, bool isWinner: true}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: isWinner ? 60 : 80,
              decoration: BoxDecoration(
                border: Border.all(color: white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          horizontalSpace(width: 4),
          Visibility(
            visible: isWinner,
            child: boldText(
              "Won",
              size: 14,
              color: red,
            ),
          )
        ],
      ),
    );
  }

  Widget buildTop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: buildProfile(
                        name: isHost ? "You" : "${player1details!.name}",
                        image: "${photoUrl + player1details!.profilePic!}",
                        isWin: false,
                        level: "${getSportLevel(player1details!)}",
                        points:
                            "${player1details!.profile != null ? calculatePlayerPoints2(player1details!.profile!) : 0}",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Visibility(
                        visible: false,
                        child: iconTitle("Icons.location_on",
                            "Hampton Court Park", Colors.blue),
                      ),
                    ),
                  ],
                ),
                verticalSpace(),
                Center(
                    child:
                        boldText("VS", color: Color.fromRGBO(182, 9, 27, 1))),
                verticalSpace(),
                Row(
                  // textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Visibility(
                          visible: false,
                          child: iconTitle("Icons.access_time", "May 29,202",
                              Color.fromRGBO(182, 9, 27, 1))),
                    ),
                    Expanded(
                      // flex: 2,
                      child: buildProfile(
                        name: isHost ? "${player2details!.name}" : "You",
                        image: "${photoUrl + player2details!.profilePic!}",
                        isWin: false,
                        level: "${getSportLevel(player2details!)}",
                        points:
                            "${player1details!.profile != null ? calculatePlayerPoints2(player2details!.profile!) : 0}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: white),
        ],
      ),
    );
  }

  Widget buildProfile({
    required image,
    required name,
    required level,
    required points,
    required isWin,
  }) {
    return Row(
      children: <Widget>[
        CircularNetworkImage(
          imageUrl: image,
          size: 44,
        ),
        horizontalSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: white,
                  fontSize: 15,
                ),
              ),
              // verticalSpace(height: 4),
              Text("$level", style: Style.tilte2TitleTextStyle),
              verticalSpace(height: 4),
              Row(
                // direction: Axis.horizontal,
                children: <Widget>[
                  horizontalSpace(),
                  Image.asset(
                    "assets/bar_chart.png",
                    height: 14,
                  ),
                  horizontalSpace(),
                  Text(
                    "$points",
                    style: TextStyle(fontWeight: FontWeight.w500, color: white),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
