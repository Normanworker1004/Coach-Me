import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

class CMEPointsPage extends StatefulWidget {
  final UserModel? userModel;

  const CMEPointsPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _CMEPointsPageState createState() => _CMEPointsPageState();
}

class _CMEPointsPageState extends State<CMEPointsPage> {
  List<BNBItem> list = [];

  bool isPlayer = false;

  var total;

  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;

    var profile = userModel!.getUserProfileDetails();
    total = "${(profile?.bookingPt ?? 0) + (profile?.appusagePt ?? 0) + (profile?.socialsharePt ?? 0)}";
    list = [
      BNBItem("Booking", "${profile?.bookingPt ?? 0}"),
      BNBItem("App Usage", "${profile?.appusagePt ?? 0}"),
      BNBItem("Social Share", "${profile?.socialsharePt ?? 0}"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        body: buildBody(context), context: context, title: "Coach&ME Points");
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        Center(child: buildTop()),
        verticalSpace(height: 24),
        Center(child: buildCenter(list[0])),
        verticalSpace(height: 24),
        buildButtonsGrid(),
        verticalSpace(height: 24),
      ],
    );
  }

  buildCenter(BNBItem text) {
    return Container(
      width: 120,
      height: 120,
      child: buildCard(Expanded(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "${text.icon}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 40,
                        color: normalBlue,
                        fontWeight: FontWeight.w500),
                  )),
                  Transform.rotate(
                    angle: m.pi * .5,
                    child: lightText("Points"),
                  ),
                ],
              ),
            ),
            // Spacer(),
            boldText("${text.title}"),
          ],
        ),
      )),
    );
  }

  buildButtonsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: buildPoints(list[1])),
        horizontalSpace(width: 24),
        Expanded(child: buildPoints(list[2]))
      ],
    );
  }

  Widget buildButtonsGridTop() {
    return Row(
      children: List.generate(
        1,
        (index) {
          return buildPoints(list[index]);
        },
      ),
    );
  }

  Widget buildPoints(BNBItem text) {
    return buildCard(Expanded(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: Text(
                "${text.icon}",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 40,
                    color: normalBlue,
                    fontWeight: FontWeight.w500),
              )),
              Transform.rotate(
                angle: m.pi * .5,
                child: lightText("Points"),
              ),
            ],
          ),
          // Spacer(),
          boldText("${text.title}"),
        ],
      ),
    ));
  }

  Widget buildTop() {
    return Card(
      shadowColor: Colors.grey.withOpacity(.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //  direction: Axis.vertical,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Positioned(
                      top: 0,
                      child: Icon(Icons.star, size: 150, color: normalBlue)),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        "$total",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontSize: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            boldText("Total Points", size: 20),
          ],
        ),
      ),
    );
  }
}
