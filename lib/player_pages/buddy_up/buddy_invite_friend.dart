import 'package:cme/app.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/filter_icon.dart';
import 'package:cme/ui_widgets/textfield_with_card.dart';
import 'package:flutter/material.dart';

class BuddyInviteFriendPage extends StatefulWidget {
  @override
  _BuddyInviteFriendPageState createState() => _BuddyInviteFriendPageState();
}

class _BuddyInviteFriendPageState extends State<BuddyInviteFriendPage> {
  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
      body: buildBody(context),
      context: context,
      rightIconWidget: filterIcon(color: Color.fromRGBO(182, 9, 27, 1)),
      title: "Invite Friend",
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildCardedTextField(hintText: "Search your friend"),
        Padding(
          padding: EdgeInsets.only(top: 64),
          child: ListView(
            children: <Widget>[
              buildContactTileTop(),
              Wrap(
                children: List.generate(12, (index) => buildContactTile()),
              ),
              verticalSpace(height: 16),
              proceedButton(
                  text: "Invite Now",
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        )
      ],
    );
  }
}

Widget buildContactTile() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: buildCard(
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Christine Smith",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  "+44 1829 122 92",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 12),
                ),
              ],
            ),
            Container(
              height: 32,
              width: 32,
              child: Visibility(
                  visible: true, child: Icon(Icons.check, color: blue)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                // color: blue,
                border: Border.all(color: blue),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildContactTileTop() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: buildCard(
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Christine Smith",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  "+44 1829 122 92",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 12),
                ),
              ],
            ),
            Container(
              height: 32,
              width: 32,
              child: Image.asset("assets/check2.png"),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildContactTileChecked() {
  return Container(
    width: double.infinity,
    height: 64,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(182, 9, 27, 1),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Christine Smith",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "+44 1829 122 92",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Card(
            margin: EdgeInsets.all(0),
            shape: CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check,
                size: 14,
                color: Color.fromRGBO(182, 9, 27, 1),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
