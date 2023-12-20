/*
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/session_review/coach_session_review_page.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/player_pages/online_session/review_page.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:flutter/material.dart';

import 'package:cme/model/coach_booking_response.dart';
import 'package:scoped_model/scoped_model.dart';

class VideoSesson2 extends StatefulWidget {
  final CoachBookingDetail details;

  const VideoSesson2({Key key, this.details}) : super(key: key);
  @override
  _VideoSesson2State createState() => _VideoSesson2State();
}

class _VideoSesson2State extends State<VideoSesson2> {
  List<BNBItem> buttons = [
    BNBItem("Chat", "assets/call1.png"),
    BNBItem("Off", "assets/call2.png"),
    BNBItem("Mute", "assets/call3.png"),
    BNBItem("Share", "assets/call4.png"),
  ];

  bool isFullScreen = true;
  bool isCoach = false;
  // var i;

  UserModel userModel;

  @override
  void initState() {
    super.initState();
    // i = Final.getId();
    // isCoach = i == 1;
    // print("+++++++$i+++++++");
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        isCoach = userModel.getUserDetails().usertype == "coach";
        return Scaffold(
          body: SafeArea(
            child: buildBody(),
          ),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isCoach ? "Chris Smith" : "Jose Mourinho",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "25:12 remaining (60 min session)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // print("i");
                    if (isCoach) {
                      // print("is coach");
                      pushRoute(
                          context,
                          CoachSessionReviewPage(
                            details: widget.details,
                          ));
                    } else {
                      pushRoute(context, SessionReviewPage());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Color.fromRGBO(182, 9, 27, 1), //rgba(182, 9, 27, 1)
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.call_end, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: Padding(
            padding:
                isFullScreen ? EdgeInsets.all(0) : EdgeInsets.only(top: 72.0),
            child: Container(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFullScreen = !isFullScreen;
                  });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      isCoach ? "assets/guy.png" : "assets/mou.png",
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        height: 150,
                        width: 100,
                        // color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Image.asset(
                            !isCoach ? "assets/guy.png" : "assets/mou.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: buildOptions(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOptions() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.transparent.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  height: 8,
                  width: 32,
                ),
              ),
              isFullScreen
                  ? SizedBox(width: 0, height: 0)
                  : Column(
                      children: <Widget>[
                        verticalSpace(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            buttons.length,
                            (index) => buildCallIcon(
                                buttons[index].icon, buttons[index].title),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCallIcon(String icon, String text) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(124, 122, 121, 1),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Image.asset(
              icon,
              width: 28,
              height: 28,
            ),
          ),
        ),
        verticalSpace(),
        Text(text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ))
      ],
    );
  }
}
*/
