import 'package:cme/app.dart';
import 'package:cme/ui_widgets/back_arrow.dart';
import 'package:cme/ui_widgets/chat_message_widgets.dart';
import 'package:cme/ui_widgets/chat_time_widget.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:flutter/material.dart';

class ChallengeChatPage extends StatefulWidget {
  @override
  _ChallengeChatPageState createState() => _ChallengeChatPageState();
}

class _ChallengeChatPageState extends State<ChallengeChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(10, 27, 59, 1),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  verticalSpace(height: 72),
                  ChatDateWidget(),
                  MessageRecievedWidget(),
                  MessageSentWidget(),
                  Spacer(),
                ],
              ),
            ),
            buildAppBar(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 24,
            spreadRadius: 32)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Card(
          color: Colors.black,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: backArrow(color: white)),
                horizontalSpace(),
                CircularImage(
                  imageUrl: "assets/girl.png",
                ),
                horizontalSpace(),
                Text(
                  "Christine Smith",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
