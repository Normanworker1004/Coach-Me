import 'package:cme/model/coach_session_response.dart';
import 'package:cme/model/fetch_buddy_up_resopnse.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/player_points.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import '../app.dart';

// ignore: must_be_immutable
class SessionDetailListTile extends StatefulWidget {
  Booking? booking;
  String imgUrl;
  String name;
  String date;
  String location;
  String level;
  bool hideDots;

  SessionDetailListTile({
    Key? key,
    this.booking,
    @required this.imgUrl = "assets/mou.jpg",
    @required this.name = "Jose Mourinho",
    @required this.date: "Today, 2pm",
    @required this.location: "Hampton Court Park",
    @required this.level: "Professional Coach",
    this.hideDots: false,
  }) : super(key: key);

  @override
  _SessionDetailListTileState createState() => _SessionDetailListTileState();
}

class _SessionDetailListTileState extends State<SessionDetailListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircularNetworkImage(
            imageUrl: widget.imgUrl,
            size: 44,
          ),
          horizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.name,
                  style: TextStyle(
                    fontFamily: App.font_name,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                // verticalSpace(height: 4),
                Text(
                  widget.level,
                  style: TextStyle(
                    fontFamily: App.font_name,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontSize: 12,
                  ),
                ),
                verticalSpace(height: 4),
                Row(
                  // direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: iconTitleExpanded(
                          "assets/booking_clock.png", widget.date, Colors.red),
                    ),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: iconTitleExpanded(
                          "assets/map_pin.png", widget.location, mapPinBlue),
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
              visible: !widget.hideDots,
              child: Icon(Icons.more_vert, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget iconTitle(icon, title, color) {
    return Row(
      children: <Widget>[
        Image.asset(
          icon,
          width: 10,
          height: 10,
        ),
        horizontalSpace(width: 4),
        Text(
          title,
          // overflow: TextOverflow.fade,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w100),
        ),
      ],
    );
  }
}

class ScheduledlListTile extends StatelessWidget {
  final BuddyUpBookingDetails b;
  final myId;

  const ScheduledlListTile({
    Key? key,
    required this.b,
    required this.myId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var p1 = b.player1User!;
    var p2 = b.player2User!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: buildProfile(
                  expLevel: "${getSportLevel(p1)}",
                  points: "${b.player1Profile != null ? calculatePlayerPoints2(b.player1Profile!) : 0}",
                  imgUrl: "${photoUrl + p1.profilePic!}",
                  name: p1.id == myId ? "You" : "${p1.name}",
                ),
              ),
              iconTitle(
                "assets/map_pin.png",
                "${b.location}",
                Colors.blue,
              ),
            ],
          ),
          // verticalSpace(),
          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 25,
              height: 25,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: iconTitle(
                      "assets/booking_clock.png", "${b.displayDate}", red)),
              Expanded(
                  flex: 3,
                  child: buildProfile(
                    expLevel: "${getSportLevel(p2)}",
                    points: "${b.player2Profile != null ? calculatePlayerPoints2(b.player2Profile!) : 0}",
                    imgUrl: "${photoUrl + p2.profilePic!}",
                    name: p2.id == myId ? "You" : "${p2.name}",
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildProfile(
    {@required imgUrl = "http://178.248.109.145:3000/assets/avatar.png",
    @required name = "not set.",
    @required expLevel = "exp. not set",
    @required points = "12345"}) {
  return Row(
    children: <Widget>[
      CircularNetworkImage(
        imageUrl: imgUrl,
        size: 45,
      ),
      horizontalSpace(),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            boldText(name, size: 14),
            Text("$expLevel", style: Style.tilte2TitleTextStyle),
            verticalSpace(height: 4),
            Row(
              children: <Widget>[
                horizontalSpace(),
                Image.asset(
                  "assets/bar_chart.png",
                  height: 14,
                ),
                horizontalSpace(),
                Text(
                  "$points",
                  style: TextStyle(fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    ],
  );
}

class ChallengeHistorylListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircularImage(
            imageUrl: "assets/mou.jpg",
            size: 44,
          ),
          horizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Jose Mourinho",
                  style: Style.titleTitleTextStyle,
                ),
                // verticalSpace(height: 4),
                Text("Professional Coach", style: Style.tilte2TitleTextStyle),
                verticalSpace(height: 4),
                Row(
                  // direction: Axis.horizontal,
                  children: <Widget>[
                    iconTitle(
                        "assets/booking_clock.png", "Today, 2pm", Colors.red),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: iconTitle("assets/map_pin.png",
                          "Hampton Court Park", Colors.blue),
                    ),
                  ],
                )
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}

class ChallengeDetailListTile extends StatelessWidget {
  final String imgUrl;
  final String? name;
  final String expLevel;
  final String points;
  final String? dateText;
  final String? locationText;
  ChallengeDetailListTile({
    Key? key,
    @required this.imgUrl: "http://178.248.109.145:3000/assets/avatar.png",
    @required this.name: "not set",
    @required this.expLevel: "not set",
    @required this.dateText: "date not set",
    @required this.points: "not set",
    @required this.locationText: "loaction not set",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircularNetworkImage(
            imageUrl: "$imgUrl",
            size: 44,
          ),
          horizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$name",
                  style: Style.titleTitleTextStyle,
                ),
                // verticalSpace(height: 4),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: <Widget>[
                    Text("$expLevel", style: Style.tilte2TitleTextStyle),
                    horizontalSpace(),
                    Image.asset(
                      "assets/bar_chart.png",
                      height: 14,
                    ),
                    horizontalSpace(),
                    Text(
                      "$points",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                verticalSpace(height: 4),
                Row(
                  // direction: Axis.horizontal,
                  children: <Widget>[
                    iconTitle("assets/booking_clock.png", "$dateText", red),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: iconTitleExpanded(
                          "assets/map_pin.png", "$locationText", blue),
                    ),
                  ],
                )
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
