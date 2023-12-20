import 'package:cme/app.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class ChallengeMAtchUpPageFinal extends StatefulWidget {
  @override
  _ChallengeMAtchUpPageFinalState createState() =>
      _ChallengeMAtchUpPageFinalState();
}

class _ChallengeMAtchUpPageFinalState extends State<ChallengeMAtchUpPageFinal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: ListView(
              children: <Widget>[
                buildTop(),
                buildScoreBoard(),
                Divider(
                  color: white,
                ),
                verticalSpace(),
                buildWinner(),
                verticalSpace(height: 64),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: <Widget>[
                proceedButton(
                  text: "Rematch",
                  onPressed: () {},
                ),
                verticalSpace(),
                borderProceedButton(
                    text: "Report",
                    onPressed: () {},
                    color: Color.fromRGBO(182, 9, 27, 1))
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget buildWinner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularImage(
          size: 100,
        ),
        horizontalSpace(),
        Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            boldText(
              "You",
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

  Widget buildScoreBoard() {
    return Column(
      children: <Widget>[
        boldText(
          "Best out of 5: Kick ups",
          color: white,
          size: 18,
        ),
        DataTable(
            // horizontalMargin: 0,
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'No',
                  style: textStyle,
                ),
              ),
              DataColumn(
                label: Text(
                  'You',
                  style: textStyle,
                ),
              ),
              DataColumn(
                label: Text(
                  'Christine Smith',
                  style: textStyle,
                ),
              ),
            ],
            rows: List.generate(
              5,
              (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(
                    '${index + 1}.',
                    style: textStyle,
                  )),
                  DataCell(Row(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: white),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: Text(
                              '19',
                              style: textStyle,
                              textAlign: TextAlign.center,
                            ),
                          )),
                      horizontalSpace(),
                      boldText(
                        "Won",
                        size: 14,
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                    ],
                  )),
                  DataCell(Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: white),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                        child: Text(
                          '19',
                          style: textStyle,
                          textAlign: TextAlign.center,
                        ),
                      ))),
                ],
              ),
            ))
      ],
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
                      child: buildProfile(name: "You", image: "assets/guy.jpg"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Visibility(
                        visible: false,
                        child: iconTitle(Icons.location_on,
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
                          child: iconTitle(Icons.access_time, "May 29,202",
                              Color.fromRGBO(182, 9, 27, 1))),
                    ),
                    Expanded(
                      // flex: 2,
                      child: buildProfile(),
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

  Widget buildProfile(
      {image = "assets/girl.png",
      name = "Christine Smith",
      level = "Semi Professional",
      points = "1023",
      isWin = false}) {
    return Row(
      children: <Widget>[
        CircularImage(
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
              Text("Professional Coach", style: Style.tilte2TitleTextStyle),
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
                    "12345",
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

  Widget iconTitle(icon, title, color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        horizontalSpace(width: 4),
        Expanded(
          child: Text(
            title,
            // overflow: TextOverflow.fade,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.w100),
          ),
        ),
      ],
    );
  }
}
